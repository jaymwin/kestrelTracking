# kestrelTracking
Repository to store and view kestrel migration tracking data from Lotek PinPoint Argos-GPS tags for Full Cycle Phenology Project

### Instructions

1. Download Argos data from their website (https://argos-system.clsamerica.com/argos-cwi2/login.html) about once per week (Username = AMERKESTREL, Password = BOISESTATE).
1. Click `Data` > `Download COM/PRV/DIAG` and make sure `Type` is set to PRV/A DS. Click `Download` to get a DSA file with locations.
1. Name DSA file by date with underscores (e.g., DSA_2019_03_10.txt) and save in `raw_argos` folder.
1. Open Lotek GPS parsing software, load DSA file as input, and export GPS+Argos csv file(s). Save csvs to `converted_argos` folder.

### Scripts

1. combine_csv_files - this file combines all of the `converted_argos` csv files, filters to non-fail records, and removes duplicate data.
1. mapview - plot tracks and points by Argos ID to view in an interactive, html map.
1. email_update - optional, email updated map with link.
1. update_map - this file runs the three previous scripts automatically.
