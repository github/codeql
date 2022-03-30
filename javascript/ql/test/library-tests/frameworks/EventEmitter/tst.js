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

class MyEventEmitter extends emitter {};

var em4 = new MyEventEmitter();
em4.on("blab", (x) => {});
em4.emit("blab", "BOH");

class ExtendsMyCustomEmitter extends MyEventEmitter{}

var em5 = new ExtendsMyCustomEmitter();
em5.on("yibity", (x) => {});
em5.emit("yibity", "yabity");

var process = require('process');
process.addListener('FirstEvent', function (first) {});
process.on('SecondEvent', function (second) {});

process.emit('FirstEvent', 'FirstData');
process.emit('SecondEvent', 'SecondData');
