// point.js
function Point(x, y) {
	this.x = x;
	this.y = y;
}

Point.prototype.distance = function() {
	return Math.sqrt(this.x*this.x+this.y*this.y);
};

exports = Point;

// client.js
var Point = require('./point');

var pyth = new Point(3, 4);
console.log(pyth.distance());