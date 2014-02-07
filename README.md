### hunter - Leche Asada
======

### Purpose:
To find graffiti/street art hot-spots in cities around the world

### Conditions:
 - Do the above with pre-existing datasources
 - Maintain accuracy to 90% for revelance of content (A nine in ten chance that a point is actually related to street art)
 - Maintain geospatial accuracy to 90% that a point falls within 500 yards of it's actual location (Very difficult to verify and very dependent on externalities)

### Priority:
 - Make the images flexible?
 - Deploy next version of app



### Things to get back to:
 - randomise pretty line, for both instances
 - Rescale the pretty lines according to page width (sorting out an event listener for window resize)
 - Build title with d3 (MAINTAIN!)
 - Look at Google maps API to better understand it
 - Add lookup search field for the google map
 - Sort out proper colour scheme
 - Consider caching the two_random_images


### Done:
 - Add spork and factorygirl to facilitate testing
 - Build data-miner-tag
 - Sort out some sort of chron job to collect the datas off IG
 - Build data-miner-user
 - Extend data-miner-user to grab all records from a user
 - See if Geocoder can determine the promixity of DB entries to one another
 - IF GEOCODE WORKS: Add promixity to the Entry table
 - Figure out what can be tested next
 - Consider implementing a paginating capture of the tag/recent/media
 - Get the most basic of D3 maps running
 - Look at Google Map API to see if I can get the zooming range to expand (DEFACTO fixed because I changed the map type to ROADMAP)
Weed out scores with a low prox score, to avoid displaying shitty data or distracting real data (Currently set to five).
 - Get the prox rake task back up from the git history...I will need it to sort out
 - See if I can do my proxing via :yandex (check Geocoder gem)
 - Get a copy running on Heroku with all the records collected to date.
 - IE, Learn how to grab a postgres data_dump and upload it to Heroku
 - Research and read up on D3
 - Mockup for the display
 - Caching the page and the primary database response, so the page isn't waiting so long for those
 - Make images clickable, with link to their instagram URL
 - scale colour over pretty line
 - Adding a d3 scale to the marker colouring
 - build down arrow (Check out SIMBOL?)

### Issues:
 - Takes very long time to run RSPEC...
 - It takes a super long time to load that first rails hit on the DB. Not sure if current caching setup will always avoid that happening to an end - user
 - hoover_tag will just start from the beginning again if it covers all of the images with that tag. (preciousgraffiti)
 - CSS styling has thrown off X and Y for the map (Particularly bad at wide zoom levels)
