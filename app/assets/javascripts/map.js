$(document).ready(function(){
    var map = new google.maps.Map(d3.select("#map").node(), {
    zoom: 12,
    center: new google.maps.LatLng(37.753887, -122.43782),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
  ////////////////////////////////////////////////////////
  var J = (function(){
    var _link = function(j) { return j.url; };
    var _lat = function(j) { return j.latitude; };
    var _lon = function(j) { return j.longitude; };
    // var _prox = function(j) { return j.prox; };
    // var _created = function(j) { return j.posted_at; };
    var _thumbnail = function(j) { return j.thumbnail_url; };

    var f = {};

    f.link      = _link;
    f.lat       = _lat;
    f.lon      = _lon;
    // f.prox     = _prox;
    // f.created   = _created;
    f.thumbnail = _thumbnail;

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
        var projection = this.getProjection(),
            padding = 10;

        var marker = layer.selectAll("svg")
          .data(data)
          .each(transformMarker)
          .enter().append("svg:svg")
          .each(transformMarker)
          .attr("class", "marker");

        marker.append("svg:rect")
            // .attr("r", function(d) {
            //    var size = d3.scale.linear()
            //     .domain([0, 200])
            //     .range([3, 10]);
            //     return size(J.likes(d));
            // })
            // .attr('fill', function(d){
            //    var color = d3.scale.linear()
            //     .domain([0, 200])
            //     .range(["red", "white"]);
            //     return color(J.likes(d));
            // })
  // rectangle for markers
              .attr("height", 3)
              .attr("width", 3)
              .attr("fill", function(d){
                  return "rgb(" + (d.prox-100) + ", 0, 0)";
              });

  // circle for markers
            // .attr("r", 4)
            // .attr('fill', 'red')
            // .attr('stroke', 'black')
            // .attr('stroke-width', '1%')

        // Add a label.
        // marker.append("svg:text")
        //     .attr("x", padding + 7)
        //     .attr("y", padding)
        //     .attr("dy", ".34em")
        //     .text(function(d) { return d.key; })
        //     .style("opacity", 0);

        // marker.append("svg:image")
        //     .each(transformImage)
        //     .attr("xlink:href", function(d) {return J.thumbnail(d);})
        //     .attr("width", 0)
        //     .attr("height", 0)
        //     .style("opacity", 1)
        //     .style("left", "100px")
        //     .style("top", "100px");

        function transformMarker(d) {
          // debugger
          d = new google.maps.LatLng(J.lat(d), J.lon(d));
          d = projection.fromLatLngToDivPixel(d);
          return d3.select(this)
              .style("left", (d.x - padding) + "px")
              .style("top", (d.y - padding) + "px");
        }

        // function transformImage(d) {
        //   d = new google.maps.LatLng(J.lat(d), J.lon(d));
        //   d = projection.fromLatLngToDivPixel(d);
        //   return d3.select(this)
        //       .attr("x", 15)
        //       .attr("y", 15);
        // }

        // show labels if zoom is greater than 10 (ie. street level)
        // console.log(map.zoom);
        // if (map.zoom >= 18) {
        //     layer.selectAll("svg")
        //       .style('width', map.zoom * 15)
        //       .style('height', map.zoom * 15)

        //     // layer.selectAll("svg").selectAll("text")
        //     //   .style('padding-right', '100px')
        //     //   .style("opacity", 1);

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


    // Bind our overlay to the map…
    overlay.setMap(map);

    // we can change map settings after we look at the data as well
    //
    // var new_center = new google.maps.LatLng(34.0838455, -118.3586526);
    // map.center = new_center;
    // map.zoom = 12;
    // overlay.setMap(map);
  });

})