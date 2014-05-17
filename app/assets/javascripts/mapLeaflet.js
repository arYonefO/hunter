$(document).ready(function(){
  if ( $('#map-leaflet').length ){
    var mapLeaflet = L.map('map-leaflet').setView([51.505, -0.09], 13);

    var backgroundTiles = L.tileLayer('https://{s}.tiles.mapbox.com/v3/examples.map-zr0njcqy/{z}/{x}/{y}.png', {
      attribution: '<a href="http://www.mapbox.com/about/maps/" target="_blank">Terms &amp; Feedback</a>'
    }) // Mapbox map tiles

    backgroundTiles.addTo(mapLeaflet);
  }
})