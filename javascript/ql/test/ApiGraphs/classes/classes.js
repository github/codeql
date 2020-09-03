const util = require('util');
const EventEmitter = require('events');

function MyStream() {
    EventEmitter.call(this);
}

util.inherits(MyStream, EventEmitter);

MyStream.prototype.write = (data) => this.emit('data', data);

function MyOtherStream() { /* use (instance (member MyOtherStream (member exports (module classes)))) */
    EventEmitter.call(this);
}

util.inherits(MyOtherStream, EventEmitter);

MyOtherStream.prototype.write = function (data) { /* use (instance (member MyOtherStream (member exports (module classes)))) */
    this.emit('data', data);
    return this;
};

module.exports.MyOtherStream = MyOtherStream;
