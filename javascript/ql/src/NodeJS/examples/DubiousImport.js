// point.js
function Point(x, y) {
	this.x = x;
	this.y = y;
}

Point.prototype.distance = function() {
	return Math.sqrt(this.x*this.x+this.y*this.y);
};

module.exports = Point;

// client.js
var Point = require('./point').Point;

var pyth = new Point(3, 4);
console.log(pyth.distance());