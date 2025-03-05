const d3 = require('d3');

function getTaint() {
    return window.name; // $ Source
}

function doSomething() {
    d3.select('#main')
        .attr('width', 100)
        .style('color', 'red')
        .html(getTaint()) // $ Alert
        .html(d => getTaint()) // $ Alert
        .call(otherFunction)
        .html(d => getTaint()); // $ Alert
}


function otherFunction(selection) {
    selection
        .attr('foo', 'bar')
        .html(getTaint()); // $ Alert
}
