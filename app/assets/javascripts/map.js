$(document).ready(function(){
    var map = new google.maps.Map(d3.select("#map").node(), {
    zoom: 13,
    center: new google.maps.LatLng(37.773887, -122.43782),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  ////////////////////////////////////////////////////////
  var J = (function(){
    var _link = function(j) { return j.url; };
    var _lat = function(j) { return j.latitude; };
    var _lon = function(j) { return j.longitude; };
    var _prox = function(j) { return j.prox; };
    // var _created = function(j) { return j.posted_at; };
    var _thumbnail = function(j) { return j.thumbnail_url; };

    var f = {};

    f.link      = _link;
    f.lat       = _lat;
    f.lon      = _lon;
    f.prox     = _prox;
    // f.created   = _created;
    f.thumbnail = _thumbnail;

    return f;
  }());
  ////////////////////////////////////////////////////////

  d3.json("http://obscure-hollows-9858.herokuapp.com/feed", function(data) {
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


        // marker.append("svg:image")
        //     .each(transformImage)
        //     .attr("xlink:href", function(d) {return J.thumbnail(d);})
        //     .attr("width", 0)
        //     .attr("height", 0)
        //     .style("opacity", 1)
        //     .style("left", "100px")
        //     .style("top", "100px");

        function transformMarker(d) {
          d = new google.maps.LatLng(J.lat(d), J.lon(d));
          d = projection.fromLatLngToDivPixel(d);
          return d3.select(this)
              .style("left", (d.x) + "px")
              .style("top", (d.y) + "px");
        }

        // function transformImage(d) {
        //   d = new google.maps.LatLng(J.lat(d), J.lon(d));
        //   d = projection.fromLatLngToDivPixel(d);
        //   return d3.select(this)
        //       .attr("x", 15)
        //       .attr("y", 15);
        // }

        //     layer.selectAll("svg").selectAll("image")
        //       .style("opacity", 1)
        //       .transition()
        //       .duration(500)
        //       .ease('bounce', 0.1)
        //       .attr('width', 300)
        //       .attr('height', 300);

        // } else {

        //     layer.selectAll("svg")
        //       .style('width', "20px")
        //       .style('height', "20px");

        //     layer.selectAll("svg").selectAll("text")
        //       .style("opacity", 0);

        //     layer.selectAll("svg").selectAll("image")
        //       .style("opacity", 0);
        // }

        // layer.selectAll("svg").selectAll("image")
        //   .on("click", function(d,i) { window.open(J.link(d));});
      };
    };
    overlay.setMap(map);
  });

})