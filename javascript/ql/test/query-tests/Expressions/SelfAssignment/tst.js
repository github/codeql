function Rectangle(x, y, width, height) {
	this.x = x;
	this.y = y;
	// NOT OK
	width = width;
	this.height = height;
}

Rectangle.prototype = {
	get area() {
		return this.width * this.height;
	},
	set area(a) {
		console.log("Setting area to " + a);
		this.width = a/this.height;
	},
	foo: function() {
		// OK
		this.area = this.area;
	}
};

// NOT OK
array[1] = array[1];

// NOT OK
o.x = o.x;

// OK
document.innerHTML = document.innerHTML;

class Point {
	constructor(x, y) {
		this.x = x;
		this.y = y;
	}
	get dist() {
		return Math.sqrt(this.x*this.x + this.y*this.y);
	}
	set dist(d) {
		console.log("Setting distance to " + d);
		this.x = d;
		this.y = 0;
	}
	foo() {
		// OK
		this.dist = this.dist;
	}
}
