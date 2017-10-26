// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// All of the Node.js APIs are available in this process.
require('bootstrap');
const st = require('smalltalk');
var i = 3;

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
    $(".addCard").click(function(){
        var me = this.id;
        // do whatever with me
        st.prompt('Add card', 'Enter card name:', 'Name')
        .then((value) => {
            var elem = document.getElementById(`${me}`);
            elem.parentNode.removeChild(elem);
            $(`#list${me}`).append(`<article class="card">${value}</article>`);
            $(`#list${me}`).append('<article class="detail">1/2</article>');
            $(`#list${me}`).append(`<Button class="addCard" id="${i}">Add</Button>`);
        });
    }); 
});

$(document).ready(function(){
    $(".addList").click(function(){
        st.prompt('Add list', 'Enter list name:', 'Name')
        .then((value) => {
            $(`<section class="list" id="list${i}"/>`).text(value).appendTo('#main_board');
            $('<header />').text("").appendTo(`#list${i}`);
            $(`<Button class="addCard" id="${i}" />`).text("Add").appendTo(`#list${i}`);
        });
        i++;
    }); 
});