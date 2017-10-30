// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
const Request = require('request');
window.$ = window.jQuery = require('jquery');
window.Bootstrap = require('bootstrap');
Elm = require("elm");
App = Elm.Main.fullscreen();

document.addEventListener('DOMContentLoaded', function () {

    initListeners(); // add listers

});

function initListeners() {
   
    
};
$(document).ready(function() {
    $("#test").click(function(){
        alert('WEEEW');
    });    
     
  }
  );