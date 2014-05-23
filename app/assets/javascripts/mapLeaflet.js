var mapLeaflet,
    backgroundTiles,
    customLeaflet = {}

$(document).ready(function(){
  if ( $('#map-leaflet').length ){
    mapLeaflet = L.map('map-leaflet', {minZoom:10}).setView([51.505, -0.09], 13);

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

    // Function for creating icon based layers

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

    // Function for creating heatmap based layers

    customLeaflet.createHeatmapLayer = function(data){
      var latlngs = []

      for (var i = 0; i < data.length; i++){
        var entry = data[i]
        latlngs.push(L.latLng(entry.lat, entry.lng))
      }
      return L.heatLayer(latlngs, {gradient: {0.4:"yellow", 0.8: "black", 1: "#1ED6B1"}, blur:40});
    }

    // Request data for the test-case (London)

    customLeaflet.dataRequest = function(latlng){
      var lat = latlng[0],
          lng = latlng[1],
          dataRequest = $.ajax({
                    url: "/feed/" + lat +"/" + lng,
                  });
      console.log("Inside the dataRequest function: " +lat)
      console.log(dataRequest)

      dataRequest.done(function(data, status, responseObject){
        if (mapLeaflet.hasLayer(customLeaflet.heatmap)){
          mapLeaflet.removeLayer(customLeaflet.heatmap)
        }
        customLeaflet.heatmap = customLeaflet.createHeatmapLayer(data)
        customLeaflet.heatmap.addTo(mapLeaflet)
        customLeaflet.thumbnailMarkers = customLeaflet.createMarkersLayer(data, {'thumbnail': true})

        mapLeaflet.on('zoomend', customLeaflet.onZoomed)

      })

      dataRequest.fail(function(data, status, responseObject){
        console.log(arguments)
      })

    }

    // Change what layer is displayed based on zoom
    // Which generates an extra 250 http requests even with Clustering
    customLeaflet.onZoomed = function(){
      if(mapLeaflet.getZoom() >= 17) {
        mapLeaflet.removeLayer(customLeaflet.heatmap);
        mapLeaflet.addLayer(customLeaflet.thumbnailMarkers);
      } else {
        mapLeaflet.removeLayer(customLeaflet.thumbnailMarkers);
        mapLeaflet.addLayer(customLeaflet.heatmap);
      }
    }

    customLeaflet.dataRequest([51, -1])
  }
})