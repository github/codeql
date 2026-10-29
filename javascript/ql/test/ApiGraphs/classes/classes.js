const util = require('util');
const EventEmitter = require('events');

function MyStream() {
    EventEmitter.call(this);
}

util.inherits(MyStream, EventEmitter);

MyStream.prototype.write = (data) => this.emit('data', data);

function MyOtherStream() { /* use=moduleImport("classes").getMember("exports").getMember("MyOtherStream").getInstance() */
    EventEmitter.call(this);
}

util.inherits(MyOtherStream, EventEmitter);

MyOtherStream.prototype.write = function (data) { /* use=moduleImport("classes").getMember("exports").getMember("MyOtherStream").getInstance() */
    this.emit('data', data);
    return this;
};

MyOtherStream.prototype.instanceProp = 1; /* def=moduleImport("classes").getMember("exports").getMember("MyOtherStream").getInstance().getMember("instanceProp") */

MyOtherStream.classProp = 1; /* def=moduleImport("classes").getMember("exports").getMember("MyOtherStream").getMember("classProp") */

module.exports.MyOtherStream = MyOtherStream;


// function-style class without .prototype reference
function MyThirdStream() { /* use=moduleImport("classes").getMember("exports").getMember("MyThirdStream").getInstance() */
}
let instance = new MyThirdStream(); /* use=moduleImport("classes").getMember("exports").getMember("MyThirdStream").getInstance() */

module.exports.MyThirdStream = MyThirdStream;


// function-style class without .prototype reference (through global variable)
(function(f) {
    foo.bar = function() { /* use=moduleImport("classes").getMember("exports").getMember("bar").getInstance() */
    }
})(foo = foo || {});

(function(f) {
    let x = new f.bar(); /* use=moduleImport("classes").getMember("exports").getMember("bar").getInstance() */
})(foo = foo || {});

module.exports.bar = foo.bar;
