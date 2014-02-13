$(document).ready(function(){

  function numRand(limit){
    return Math.floor(Math.random()*limit);
  }

  function scatter(e){
    console.log('it fires');
    // console.log(e)
    console.log(this)
    var entry = $(this).offset();
    console.log(entry)
    // var origTop = entry.top
    // var origLeft = entry.left
    var randTop = entry.top + (numRand(151) - 75);
    var randLeft = entry.left + (numRand(151) - 75);
    $(this).offset( { top: randTop, left: randLeft } );
    setTimeout($(this).offset(entry), 5000);
  }

  // $('#map').on('mouseover', '.graffiti svg', scatter);

  // eventlistener to fire function

  // scatter function

  // Grab a random number

  // changes x,y of point

  //

  // reverses change

  // new plan:

  // collect x and y

  // randomnumber add/sub from them

  // offset element with new values

  // interval delay

  // offset element with original values
});