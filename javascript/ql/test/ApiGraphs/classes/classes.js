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

MyOtherStream.prototype.instanceProp = 1; /* def (member instanceProp (instance (member MyOtherStream (member exports (module classes))))) */

MyOtherStream.classProp = 1; /* def (member classProp (member MyOtherStream (member exports (module classes)))) */

module.exports.MyOtherStream = MyOtherStream;
