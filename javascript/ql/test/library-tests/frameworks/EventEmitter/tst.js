var emitter = require('events').EventEmitter;

var em = new emitter();

// Splitting different channels
em.addListener('FirstEvent', function (first) {});
em.on('SecondEvent', function (second) {});

em.emit('FirstEvent', 'FirstData');
em.emit('SecondEvent', 'SecondData');

// Splitting different emitters.
var em2 = new emitter();
em2.addListener('FirstEvent', function (otherFirst) {});
em2.emit('FirstEvent', 'OtherFirstData');

// Chaining.
var em3 = new emitter();
em3.on("foo", (foo) => {}).on("bar", (bar) => {});
em3.emit("foo", "foo");
em3.emit("bar", "bar");

// Returning a value does not work here. 
var em4 = new emitter();
em3.on("bla", (event) => {
	event.returnValue = "foo"
});
em3.emit("bla", "blab");
