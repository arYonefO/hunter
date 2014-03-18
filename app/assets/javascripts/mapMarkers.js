var d3ToMap = {}

d3ToMap.numRand = function(limit){
  return Math.floor(Math.random()*limit);
}

d3ToMap.maplng = function(){
  return graffMap.map.getCenter().lng()
}

var entry = (function(){
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

d3ToMap.applyd3ToMap = function(data){
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
                          .on('mouseover', scatter);

        marker.append("svg:rect")

              .attr("height", 6)
              .attr("width", 6)
              .attr('fill', function(d){
                var colour = d3.scale.linear()
                                     .domain([0, 100])
                                     .range(["#0C5244", "#1ED6B1"]);
                return colour(entry.prox(d)/6 + 10);
              })
              .attr("stroke", "#0f0f02")
              .attr("stroke-width", 0.5)

              console.log(graffMap.map.zoom)

        function transformMarker(d) {
          d = new google.maps.LatLng(entry.lat(d), entry.lon(d));
          d = projection.fromLatLngToDivPixel(d);
          return d3.select(this)
              .style("left", (d.x) + "px")
              .style("top", (d.y) + "px");
        }

        function scatter(d){
          console.log("the event has fired")
          d = new google.maps.LatLng(entry.lat(d), entry.lon(d));
          d = projection.fromLatLngToDivPixel(d);
          d3.select(this)
            .transition()
            .duration(2000)
            .style("left", (d.x + (d3ToMap.numRand(301) - 150)) + "px")
            .style("top", (d.y + (d3ToMap.numRand(301) - 150)) + "px")
            .transition()
            .delay(12000)
            .duration(2000)
            .style("left", (d.x) + "px")
            .style("top", (d.y) + "px")
        }

      };
    };
  overlay.setMap(graffMap.map);
}

$(document).ready(function(){
  var url = "http://graffi.so/feed/" + d3ToMap.maplng()
  d3.json(url, function(data){
    d3ToMap.applyd3ToMap(data)
  })
})