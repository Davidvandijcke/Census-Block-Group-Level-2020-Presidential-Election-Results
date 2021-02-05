# Census-Block-Group-Level-2020-Presidential-Election-Results
A dataset ('data/out/precinct_cbgs_all_2020.csv.gz') with estimates of Census Block Group level 2020 presidential election results, and the underlying data and code that generated it. For the 2016 CBG-level results, see [here](https://github.com/Davidvandijcke/Census-Block-Group-Level-2016-Presidential-Election-Results).

Derived from the [dataset](https://github.com/TheUpshot/presidential-precinct-map-2020) compiled by the New York Times and the Census Block Group [shapefiles](https://www2.census.gov/geo/tiger/TIGER2019/BG/) from the Census Bureau. All non-voting variables are defined and named as in those shapefiles. All voting variables are defined and named as in the NYT geojson. For a description of the matching algorithm, see Van Dijcke and Wright (2021). Credit to [Maria Milosh](https://scholar.google.com/citations?user=j7_LsGoAAAAJ&hl=en) for coding help.

Download the raw data that goes in the `/data/` folder [here](https://www.dropbox.com/sh/nyuiwr1mbbprjx4/AABA051-RLh4rTCMzTfrf7Y-a?dl=0).

Please cite: 

Park, Alice, Charlie Smart, Rumsey Taylor, and Miles Watkins. "An Extremely Detailed Map of the 2020 Election." The New York Times. February 02, 2021. Accessed February 04, 2021. https://www.nytimes.com/interactive/2021/upshot/2020-election-map.html.

Van Dijcke, David and Wright, Austin L., Profiling Insurrection: Characterizing Collective Action Using Mobile Device Data (January 31, 2021). Available at SSRN: https://ssrn.com/abstract=3776854


| variable name     | description                                                                     |
|-------------------|--------------------------------------------------------------------             |
| `statefp`         | State FIPS code                                                                 |
| `countyfp`        | County FIPS code                                                                |
| `tractce`         | Tract FIPS code                                                                 |
| `blkgrpce`        | Block Group FIPS code                                                           |
| `geoid`           | Full 12-digit FIPS code                                                         |
| `intptlat`        | Current latitude of the internal point                                          |
| `intptlon`        | Current longitude of the internal point                                         |
| `votes_total`     | total votes in the precinct, including for third-party candidates and write-ins |
| `votes_rep`       | votes received by Donald Trump                                                  |
| `votes_dem`       | votes received by Joseph Biden                                                  |

# Caveats

⚠️ See the note on the NYT [Git repository](https://github.com/TheUpshot/presidential-precinct-map-2020) about how they drew precinct boundaries. In short, some of the precinct boundaries are not entirely accurate, as the NYT drew them themselves. Since they did this by Census Block Group, however, it shouldn't affect the  CBG match too badly.

⚠️ The current NYT dataset is incomplete. Therefore, we only include states that either have full precinct coverage, or where precinct-level results are missing entirely for certain counties -- as in that case, we can be sure there won't be any precincts missing within a given CBG. Nonetheless: use with caution (check the data). For a list of state-specific data collection issues, see the NYT [Git repository](https://github.com/TheUpshot/presidential-precinct-map-2020). 
The states currently included are: 
`AZ`, `AR`, `CO`, `DE`, `DC`, `GA`, `HI`, `ID`, `IA`, `IL`, `ID`, `KS`, `MD`, `MA`, `MI`, `MN`, `MS`, `MT` , `NE`, `NV`, `NM`, `NY`, `NC`, `ND`, `OH`, `OK`, `OR`, `PA`, `SD`, `TN`, `UT`, `WA`, `WV`, `WI`, `WY`.                                      
