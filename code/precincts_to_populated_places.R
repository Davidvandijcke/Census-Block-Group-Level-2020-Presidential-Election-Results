#***********************************************************************

# precincts_to_cbg.R
# Intersect NYT precinct-level 2020 election shapefiles
# with stackedstate-level cbg shapefiles

#***********************************************************************


# Setup -------------------------------------------------------------------

if (!require("pacman", character.only=TRUE)) {install.packages("pacman", dependencies=TRUE)}; require("pacman")
pacman::p_load(sf, tidyverse, rgdal, wrapr, rgeos, tmap, purrr, geojsonsf, here, data.table, dplyr, maps)




#***********************************************************************
#### INTERSECT 2020 SHAPEFILE ####
#***********************************************************************

dir_base <- here::here()
dir <- gsub("/code", "/data", dir_base)


cbg_stacked <- sf::read_sf(file.path(dir, 'USA_Census_Populated_Place_Areas')) %>%
  st_zm() %>% # to avoid 'OGR: not enough data' error
  st_transform('+proj=laea +lat_0=10 +lon_0=-81 +ellps=WGS84 +units=m +no_defs') %>%
  st_buffer(0) %>%
  set_names(colnames(.) %>% str_to_lower())

cbg_twenty <- # get NYT precinct-level results
  geojsonsf::geojson_sf(file.path(dir, 'precincts-with-results.geojson')) %>%
  st_zm() %>% # to avoid 'OGR: not enough data' error
  st_transform('+proj=laea +lat_0=10 +lon_0=-81 +ellps=WGS84 +units=m +no_defs') %>%
  st_buffer(0) %>%
  set_names(colnames(.) %>% str_to_lower())


precincts_selected <- st_intersects(cbg_stacked, cbg_twenty)
cbg_stacked <- cbg_stacked[sapply(precincts_selected,
                              function(x) length(x) > 0), ]
precincts_selected <- precincts_selected[sapply(precincts_selected,
                                                function(x) length(x) > 0)]

# get columns of interest
cols_select <- c('votes_total', 'votes_rep', 'votes_dem')
g16 <- cols_select %>% na.omit()
cbg_stacked[cols_select] <- as.numeric('')




# loop over each row and get weighted votes for each populated places from intersected precincts
for(j in 1:nrow(cbg_stacked) ) {
  # narrow down what to intersect:
  cbg_twenty %>%
    slice(precincts_selected[[j]]) -> precincts_matched

  # intersect:
  sf::st_intersection(cbg_stacked[j, ],
                      precincts_matched) -> intersection

  share <- sf::st_area(intersection) / sf::st_area(precincts_matched)
  # precincts.matched$label <- round(share, 2)

  purrr::map(precincts_matched %>% # weight election results of precincts by share of precinct area that overlaps w CBG,
               # then assign to CBG
               st_drop_geometry %>%
               select(all_of(cols_select)),
             function(x)
               unlist(x)  %>% `%*%` (share)
  ) %>%
    unlist() %>%
    as.list() -> cbg_stacked[j, g16]

} # end j loop

cbg_out <- cbg_stacked %>% sf::st_drop_geometry() %>% 
  dplyr::select(statefp, countyfp, tractce, blkgrpce, geoid, intptlat, intptlon, votes_total, votes_rep, votes_dem) # to data table + select columns


fwrite(cbg_out, file.path(dir, 'out', "census_populated_places_all_2020.csv.gz"))





