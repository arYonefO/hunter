var mapLeaflet,
    backgroundTiles,
    myIcon,
    customLeaflet = {}

$(document).ready(function(){
  if ( $('#map-leaflet').length ){
    mapLeaflet = L.map('map-leaflet').setView([51.505, -0.09], 13);

    backgroundTiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/examples.map-zr0njcqy/{z}/{x}/{y}.png', {
      attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
    }) // Mapbox map tiles

    backgroundTiles.addTo(mapLeaflet);

    // Icon test-case
    myIcon = L.divIcon({className: 'leaflet-div-icon'});
    L.marker([51.505, -0.089], {icon: myIcon}).addTo(mapLeaflet);

    // Request data test-case

    customLeaflet.createMarkersLayer = function(data){
      var convertedPoints = []

      for (var i = 0; i < data.length; i++){
        var entry = data[i];

        marker = new L.marker([entry.lat, entry.lng], {icon: myIcon})

        convertedPoints.push(marker)
      }
      // console.log(convertedPoints)
      // So, an issue exists with how the markers are being put into a layer
      // addLayer may not be working because we are passing it an array of markers, which might not be correct.
      var markerLayer = L.layerGroup(convertedPoints).addTo(mapLeaflet)
    }

    dataRequest = $.ajax({
                    url: "/feed/51/-1",
                  });

    dataRequest.done(function(data, status, responseObject){
      customLeaflet.createMarkersLayer(data)
    })

    dataRequest.fail(function(data, status, responseObject){
      console.log(arguments)
    })
  }
})