CyAutoGeoTag
============

An automated GPS tagger for images those have missing GPS data. Also integrated with [Google Picasa](http://picasa.google.com/).

###Summary
This program reads some image names from arguments, and based on images with GPS data, it simply deciedes best GPS tag for the ones that lacks GPS info and saves them.

###Usage Scenario
I often travel with my faimly a nad they took pictures a lot. But their camera does not have an GPS receiver. My iPhone 4 has and my photos have GPS tags. So I can easily browse my photos on map using Picasa or iPhone Map view in Photos app.

To make my parents and friends' photos location aware, I simply run this program and it automtaically adds GPS tag to them. So all of our photos are browsabable through maps.

###Caveats
This program deciedes the location by reading timestamp on pictures and calculates the proper tag. If you will use this program for photos that taken from several cameras, be sure that time is synced. If not, there are several programs for batch photo time syncing. Also Picasa itself has a basic time syncing feature.

###Integration with Picasa
Although you can use that program as batch, It migth be useful to use with Picasa. So you can order photos by time, and while browsing, select related photos and click the Auto Geo Tag button.
More information about Picasa button is under picasa-button folder.

