hunter - Leche Asada
======

Purpose:
To find graffiti/street art hot-spots in cities around the world

Conditions:
-Do the above with pre-existing datasources
-Maintain accuracy to 90% for revelance of content (A nine in ten chance that a point is actually related to street art)
-Maintain geospatial accuracy to 90% that a point falls within 500 yards of it's actual location (Very difficult to verify and very dependent on externalities)

Priority:
-Consider implementing a paginating capture of the tag/recent/media
-Mockup for the display

Done:
-Add spork and factorygirl to facilitate testing
-Build data-miner-tag
-Sort out some sort of chron job to collect the datas off IG
-Build data-miner-user
-Extend data-miner-user to grab all records from a user
-See if Geocoder can determine the promixity of DB entries to one another
-IF GEOCODE WORKS: Add promixity to the Entry table
-Figure out what can be tested next