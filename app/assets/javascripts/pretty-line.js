$(document).ready(function(){
    var dataset = [1,2,3,4,3,5,7,6,8,9,6,3,5,7,8,7,5,3,2,3,2,1,3,4,7,5,6,4,3,2,1,2,1]
    var barPadding = 2
    var w = (window.innerWidth - 30) // IE 6 and below can go away
    var h = 70
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
                .attr("fill", "teal");
          })();