$(document).ready(function(){
    var map = new google.maps.Map(d3.select("#map").node(), {
    zoom: 13,
    minZoom: 10,
    center: new google.maps.LatLng(37.773887, -122.43782),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var acSetup = {
    types: ['(regions)']
  }

  var userInput = document.getElementById('searchfield')
  console.log(userInput)

  var autocomplete = new google.maps.places.Autocomplete(userInput, acSetup);
  autocomplete.bindTo('bounds', map);

  google.maps.event.addListener(autocomplete, 'place_changed', function() {
    var place = autocomplete.getPlace();
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(13);
    }
  })

  ////////////////////////////////////////////////////////
  var J = (function(){
    // var _link = function(j) { return j.url; };
    var _lat = function(j) { return j.lat; };
    var _lon = function(j) { return j.lng; };
    var _prox = function(j) { return j.prox; };
    // var _created = function(j) { return j.posted_at; };
    // var _thumbnail = function(j) { return j.thumbnail_url; };

    var f = {};

    // f.link      = _link;
    f.lat       = _lat;
    f.lon      = _lon;
    f.prox     = _prox;
    // f.created   = _created;
    // f.thumbnail = _thumbnail;

    return f;
  }());
  ////////////////////////////////////////////////////////

  d3.json("http://localhost:3000/feed", function(data) {
    console.log(data)
    var overlay = new google.maps.OverlayView();

    overlay.onAdd = function() {

      var layer = d3.select(this.getPanes().overlayMouseTarget)
          .append("div")
          .attr("class", "graffiti");

      overlay.draw = function() {
        var projection = this.getProjection(), padding = 10;

        var marker = layer.selectAll("svg")
          .data(data)
          .each(transformMarker)
          .enter().append("svg:svg")
          .each(transformMarker)
          .attr("class", "marker");

        marker.append("svg:rect")
              .attr("height", 8)
              .attr("width", 8)
              .attr('fill', function(d){
                 var colour = d3.scale.linear()
                  .domain([0, 100])
                  .range(["black", "red"]);
                  return colour(J.prox(d)/6 + 20);
              })


        function transformMarker(d) {
          d = new google.maps.LatLng(J.lat(d), J.lon(d));
          d = projection.fromLatLngToDivPixel(d);
          return d3.select(this)
              .style("left", (d.x) + "px")
              .style("top", (d.y) + "px");
        }

      };
    };
    overlay.setMap(map);
  });

})