const d3 = require('d3');

function getTaint() {
    return window.name;
}

function doSomething() {
    d3.select('#main')
        .attr('width', 100)
        .style('color', 'red')
        .html(getTaint()) // NOT OK
        .html(d => getTaint()) // NOT OK
        .call(otherFunction)
        .html(d => getTaint()); // NOT OK
}


function otherFunction(selection) {
    selection
        .attr('foo', 'bar')
        .html(getTaint()); // NOT OK
}
