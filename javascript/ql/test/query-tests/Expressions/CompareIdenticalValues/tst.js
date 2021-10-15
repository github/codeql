function Rectangle(x, y, width, height) {
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
}

Rectangle.prototype.contains = function(x, y) {
	return (this.x <= x &&
            x < this.x+this.width) &&
	       (y <= y &&
	        y < this.y+this.height);
};

// OK
"true" == true;

// OK
f() != f(23);

// NOT OK
(function() { }) == (function() {});

 // OK
x === y;

// OK
true === false;

// OK
function isNan(n) {
  return n !== n;
}

// OK
function checkNaN(x) {
  if (x === x) // check whether x is NaN
    return false;
  return true;
}

// OK (though wrong in other ways)
function same(x, y) {
  if (x === y)
    return true;
  // check if both are NaN
  return +x !== +x && +y !== +y;
}