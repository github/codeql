const EventEmitter = require("events");

class MyEmitter extends EventEmitter {
	foo() {
		this.emit("foo", "bar");
		this.on("foo", (data) => {});
	}
}

class MySecondEmitter extends EventEmitter {
	foo() {
	  this.emit("bar", "baz");
      this.on("bar", (data) => {});
	}
}

var x = new MySecondEmitter();
x.emit("bar", "baz2");

var y = new MySecondEmitter();
y.emit("bar", "baz3");
y.on("bar", (yData) => {})