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
