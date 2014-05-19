var mapLeaflet,
    backgroundTiles,
    customLeaflet = {},
    dataRequest

$(document).ready(function(){
  if ( $('#map-leaflet').length ){
    mapLeaflet = L.map('map-leaflet', {minZoom:8}).setView([51.505, -0.09], 13);

    backgroundTiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/examples.map-zr0njcqy/{z}/{x}/{y}.png', {
      attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
    }) // Mapbox map tiles

    backgroundTiles.addTo(mapLeaflet);

    // Set Icon Constructors
    customLeaflet.cssDivIcon = L.divIcon({className: 'leaflet-div-icon'});

    customLeaflet.ThumbnailIcon = L.Icon.extend({
    options: {
              iconSize:     [60, 60],
              iconAnchor:   [5, 15]
            }
    })

    var exampleThumbURL = "http://origincache-prn.fbcdn.net/10358282_1435179943401252_572496191_s.jpg",
    testThumbnailIcon = new customLeaflet.ThumbnailIcon({iconUrl: exampleThumbURL})

    L.marker([51.505, -0.089], {icon: testThumbnailIcon}).addTo(mapLeaflet);

    // Boring regular markers

    customLeaflet.createMarkersLayer = function(data, opts){
      var convertedPoints = [],
      marker,
      icon,
      markerCluster = new L.MarkerClusterGroup()
      for (var i = 0; i < data.length; i++){
        var entry = data[i];
        if (opts['thumbnail'] === true){
          icon = new customLeaflet.ThumbnailIcon({iconUrl: entry.thumb})
        } else {
          icon = customLeaflet.cssDivIcon
        }
        marker = new L.marker([entry.lat, entry.lng], {icon: icon})
        convertedPoints.push(marker)
      }
      if (opts['thumbnail'] === true){
        return markerCluster.addLayers(convertedPoints)
      } else {
        return L.layerGroup(convertedPoints)
      }
    }

    // Request data for the test-case (London)

    dataRequest = $.ajax({
                    url: "/feed/51/-1",
                  });

    dataRequest.done(function(data, status, responseObject){
      customLeaflet.plainMarkers = customLeaflet.createMarkersLayer(data, {'thumbnail': false})
      customLeaflet.plainMarkers.addTo(mapLeaflet)
      customLeaflet.thumbnailMarkers = customLeaflet.createMarkersLayer(data, {'thumbnail': true})

      mapLeaflet.on('zoomend', customLeaflet.onZoomed)

    })

    dataRequest.fail(function(data, status, responseObject){
      console.log(arguments)
    })

    // Change what layer is displayed based on zoom
    // Which generates an extra 1500 http requests on display :( Clustering?
    customLeaflet.onZoomed = function(){
      console.log(customLeaflet.plainMarkers)
      console.log(customLeaflet.thumbnailMarkers)
      if(mapLeaflet.getZoom() >= 17) {
        mapLeaflet.removeLayer(customLeaflet.plainMarkers);
        mapLeaflet.addLayer(customLeaflet.thumbnailMarkers);
      } else {
        mapLeaflet.removeLayer(customLeaflet.thumbnailMarkers);
        mapLeaflet.addLayer(customLeaflet.plainMarkers);
      }
    }
  }
})