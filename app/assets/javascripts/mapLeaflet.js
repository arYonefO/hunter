var mapLeaflet,
    backgroundTiles,
    customLeaflet = {}


    customLeaflet.pickStartCity = function(){
      var cities = [
      [51.505,-0.09],
      [-33.85, 151.2],
      [-37.8, 144.95],
      [40.717, -74],
      [37.767, -122.417],
      [47.6, -122.317],
      [-23.55, -46.633],
      [52.517, 13.417],
      [48.867, 2.333],
      [34.05, -118.25],
      [40.4, -3.683],
      [41.383, 2.183],
      [43.65, -79.383],
      [-22.9, -43.233],
      [37.804, -122.271],
      [19.4, -99.117],
      [51.45, -2.583],
      [4.598, -74.076],
      [38.7, -9.183],
      [-34.6, -58.367],
      [-33.45, -70.667]
      ],
      city_index = d3ToMap.numRand(cities.length);
      customLeaflet.starter = cities[city_index]
    }

$(document).ready(function(){
  if ( $('#map-leaflet').length ){
    customLeaflet.pickStartCity()
    mapLeaflet = L.map('map-leaflet', {minZoom:10})

    //Sets default map location

    mapLeaflet.setView(customLeaflet.starter, 13);

    backgroundTiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/tokugawa.iblnm3f7/{z}/{x}/{y}.png', {
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

    customLeaflet.ThumbnailIconExtended = L.Icon.extend({
    options: {
              iconSize:     [220, 220],
              iconAnchor:   [110, 0]
            }
    })

    // On Click event handler function for markers
    customLeaflet.presentMarker = function(e){
      if (e.target.options.zIndexOffset === 0 || e.target.options.zIndexOffset === 1000000)
      {
        var extendedIcon = new customLeaflet.ThumbnailIconExtended({iconUrl: e.target.options.thumb})
        e.target.setIcon(extendedIcon)
        e.target.setZIndexOffset(9000000 + customLeaflet.zIndexOffsetIncrement())
        e.target.closePopup() // This is confusing. closePopup() is opening the popup
      } else {
        var regularIcon = new customLeaflet.ThumbnailIcon({iconUrl: e.target.options.thumb})
        e.target.setIcon(regularIcon)
        e.target.setZIndexOffset(0)
        e.target.openPopup() // This is confusing. openPopup() is closing the popup
      }
    }


    // Ensure the last clicked image pops up highest

    customLeaflet.currentOffset = 0

    customLeaflet.zIndexOffsetIncrement = function(){
      customLeaflet.currentOffset ++;
      return customLeaflet.currentOffset
    }


    // Function for creating icon based layers

    customLeaflet.createMarkersLayer = function(data, opts){
      var convertedPoints = [],
      marker,
      icon,
      markerCluster = new L.MarkerClusterGroup({spiderfyDistanceMultiplier: 1.6})
      for (var i = 0; i < data.length; i++){
        var entry = data[i];
        if (opts['thumbnail'] === true){
          icon = new customLeaflet.ThumbnailIcon({iconUrl: entry.thumb})
        } else {
          icon = customLeaflet.cssDivIcon
        }
        marker = new L.marker(
                            [entry.lat, entry.lng],
                            {
                              icon: icon,
                              alt: "Image not available :(",
                              thumb: entry.thumb
                            }
                            )
        marker.on('click', customLeaflet.presentMarker);
        var linkToInstagram = "<a href='" + entry.url + "' target='_blank'>See this on Instagram</a>"
        marker.bindPopup(linkToInstagram, {className: 'graff-popup', closeOnClick: false, closeButton: false});
        if( entry.thumb.length ){ convertedPoints.push(marker) }

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
      return L.heatLayer(latlngs, {gradient: {0.3: "#FFD700", 0.4:"#34495e", 0.8: "#0AC899"}, blur:40});
    }

    // Request data for all cases

    customLeaflet.dataRequest = function(latlng){
      var lat = latlng[0],
          lng = latlng[1],
          dataRequest = $.ajax({
                    url: "/feed/" + lat +"/" + lng,
                  });

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

    customLeaflet.onLocationFound = function(data){
      var deviceLatLng = customLeaflet.roundedLatLng([data.latlng.lat, data.latlng.lng])
      customLeaflet.dataRequest(deviceLatLng)
      mapLeaflet.setView(data.latlng)
    }

    customLeaflet.onLocationError = function(e){
      alert(e.message)
      console.log("Well if you don't want to hand over your location, that's fine")
    }

    customLeaflet.deviceLocation = function() {
      mapLeaflet.locate()
      mapLeaflet.on('locationfound', customLeaflet.onLocationFound)
      mapLeaflet.on('locationerror', customLeaflet.onLocationError)
    }

    customLeaflet.float2int = function(value) {
         return value | 0;
    }

    customLeaflet.roundedLatLng = function(latlng){
    var roundedLat = customLeaflet.float2int(latlng[0]),
        roundedLng = customLeaflet.float2int(latlng[1]);
    return [roundedLat, roundedLng]
    }

    // Adds info pane to map
    var info = L.control();

    info.onAdd = function(map) {
        this._div = L.DomUtil.create('div', 'info'); // create a div with a class "info"
        this.update();
        return this._div;
    };

    info.update = function() {
        this._div.innerHTML = '<h4>Graffi.so: Global Street Art Finder</h4>' +
            '<b>' + '<span>Zoom in to explore</span>';
    };

    info.addTo(mapLeaflet);

    // populate initial map with data
    var startLatLng = customLeaflet.roundedLatLng(customLeaflet.starter)
    customLeaflet.dataRequest(startLatLng)

    // Use device location
    $('#device-location').on('click', customLeaflet.deviceLocation)
  }
})