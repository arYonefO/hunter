$(document).ready(function(){

  graffMap = {
    map: new google.maps.Map(d3.select("#map").node(), {
    zoom: 13,
    minZoom: 10,
    center: new google.maps.LatLng(37.773887, -122.43782),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }),
    mapStyle: [ { "stylers": [ { "hue": "#a200ff" } ]  },
                { "featureType": "water",
                  "stylers": [ { "lightness": -8 },
                               { "gamma": 0.96 } ] },
                { "featureType": "road",
                  "elementType": "geometry",
                  "stylers": [ { "lightness": 100 },
                               { "visibility": "simplified" } ] },
                { "featureType": "road",
                  "elementType": "labels",
                  "stylers": [ { "visibility": "off" } ] },
                { "featureType": "road.arterial",
                  "elementType": "labels.text",
                  "stylers": [ { "visibility": "on" } ] },
                { "featureType": "road.local",
                  "elementType": "labels.text",
                  "stylers": [ { "visibility": "on" } ] },
                { "featureType": "poi.park",
                  "elementType": "labels.icon",
                  "stylers": [ { "lightness": -14 },
                              { "visibility": "simplified" } ] },
                { "featureType": "poi",
                  "elementType": "labels",
                  "stylers": [ { "visibility": "off" } ] }
              ]

  }


  graffMap.map.set('styles', graffMap.mapStyle)

  var acSetup = { types: ['(regions)'] }

  var userInput = document.getElementById('searchfield')

  var autocomplete = new google.maps.places.Autocomplete(userInput, acSetup);
  autocomplete.bindTo('bounds', graffMap.map);

  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    var place = autocomplete.getPlace();
    if (place.geometry.viewport) {
      graffMap.map.fitBounds(place.geometry.viewport);
      graffMap.map.setZoom(12);
    } else {
      map.setCenter(place.geometry.location);
      graffMap.map.setZoom(12);
    }
  })
})