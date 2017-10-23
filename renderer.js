// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
require('bootstrap');

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