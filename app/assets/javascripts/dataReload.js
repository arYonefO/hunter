$(document).ready(function(){

  $("#searchfield").keyup(function (e) {
    if (e.keyCode == 13) {
      setInterval(function(){var url = "http://localhost:3002/feed/" + d3ToMap.maplng()
      d3.json(url, function(data){
        d3ToMap.applyd3ToMap(data)
      })
    },500)
    }
  })
})