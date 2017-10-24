// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
require('bootstrap');
const st = require('smalltalk');

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

$(document).ready(function(){
    $(".addList").click(function(){
        var me = this.id;
        // do whatever with me
        st.prompt('Add list', 'Enter list name:', 'Name')
        .then((value) => {
            $(`#list${me}`).append(`<article class="card">${value}</article>`);
            $(`#list${me}`).append('<article class="detail">1/2</article>');
        });
    }); 
});