function Point(x, y) {
    this.x = x;
    this.y = y;

    // NOT OK
    this.dist = function() {
        return Math.sqrt(this.x*this.x + this.y*this.y);
    };

    // OK
    this.getOriginalX = function() {
        return x;
    };

    // OK
    this.getOriginalXGetter = function() {
        return function() {
            return x;
        };
    };

    // OK
    this.getOtherOriginalXGetter = function() {
        function getter() {
            return x;
        }

        return getter;
    };

    if (x === 0)
        // OK
        this.dist = function() {
            return y;
        };

    var o = {};
    // OK
    o.f = function() { return 23; };
}

// OK
var o = new(function() {
    this.f = function() { return 42 };
});

// OK
(function() {
    this.move = function(dx, dy) {
        this.x += dx;
        this.y += dy;
    };
}).call(Point.prototype);