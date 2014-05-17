var graffMap


$(document).ready(function(){
  if ( $('#map').length ){
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
                ],
        data_url: "http://localhost:3002/feed/"
    }

    var mapSetUp = (function(){
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
        setTimeout(function(){ var url = graffMap.data_url + d3ToMap.mapCoords()
          d3.json(url, function(data){ d3ToMap.applyd3ToMap(data) })
        },100)
        $.ajax({
          type: "POST",
          url: "/search_term",
          data: { 'search_term': place.formatted_address,
                  'lat': place.geometry.location.lat(),
                  'lng': place.geometry.location.lng()
                  }
        });
      })
    }())
  }
}) // document.ready