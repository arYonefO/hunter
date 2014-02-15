$(document).ready(function(){

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

  d3.json("http://www.graffi.so/feed", function(data) {
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
              .attr("height", 6)
              .attr("width", 6)
              .attr('fill', function(d){
                 var colour = d3.scale.linear()
                  .domain([0, 100])
                  .range(["#602A75", "#1AA186"]);
                  return colour(J.prox(d)/6 + 20);
              })
              .attr("stroke", "#0f0f02")
              .attr("stroke-width", 0.5)

              console.log(graffMap.map.zoom)

        function transformMarker(d) {
          d = new google.maps.LatLng(J.lat(d), J.lon(d));
          d = projection.fromLatLngToDivPixel(d);
          return d3.select(this)
              .style("left", (d.x) + "px")
              .style("top", (d.y) + "px");
        }
      };
    };

    overlay.setMap(graffMap.map);
  });

})