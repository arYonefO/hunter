$(document).ready(function(){
    var dataset = [1,2.1,3,4,3,5,7,6,8,9,6,3,5,7,8,7.1,5.4,3,2,3.4,2,1.3,3,4.6,7,5.3,6,4.4,3,2,1.1,2.2,1]
    var barPadding = 2
    var w = (window.innerWidth - 30) // IE 6 and below can go away
    var h = 76
    var svg = d3.selectAll('.pretty-line')
                .append("svg")
                .attr("width", w)
                .attr('height', h);

                svg.selectAll("rect")
                .data(dataset)
                .enter()
                .append("rect")
                .attr("x", function(d,i){
                    return i * (w / dataset.length);
                })
                .attr("y", function(d){
                    return d*3;
                })
                .attr('width', w / dataset.length - barPadding)
                .attr('height', function(d){
                    return d*5 + 2;
                })
                .attr('fill', function(d){
                    var colour = d3.scale.linear()
                         .domain([0, 8])
                         .range(["#9b59b6", "#1abc9c"]);
                        return colour(d+2);
                })
                .attr('stroke', '#000000')
                .attr('stroke-width', 1)
          });