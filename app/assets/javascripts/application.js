// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .



$(window).load(function() {
  initialize();
});
var map ; 

   function showpos()
  {    
    // Adding a marker to the map
    var marker = new google.maps.Marker({
      position: map.getCenter(),
      map: map,
      title:"click me !",
      });
  }
  function showme()
  {
    if (map.marker)
      map.infoowindow.open(map,map.marker)
  }
  function initialize()
{
	console.log("init");
	var mapDiv = document.getElementById('mapdiv'); 
    var options = {
        zoom: 12,
        center: new google.maps.LatLng(22.55, 114.07),
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        scaleControl: true,
        noclear: true 
    };
    map = new google.maps.Map(mapDiv,options); 
    //创建一个标记，
    map.marker = new google.maps.Marker({
      position: map.getCenter(),
      map: map,
      title:"my position"   
      }); 
     //创建一个弹出框 。
    map.infoowindow = new google.maps.InfoWindow({content:"hello,World"}) ; 
    google.maps.event.addListener(map.marker,"click",function() {
        map.infoowindow.open(map,map.marker)
    }) ;
    console.log("created map");
    // setTimeout("showme();",2000) ;
}

