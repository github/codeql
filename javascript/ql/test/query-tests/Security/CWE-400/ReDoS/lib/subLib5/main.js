module.exports = function (name) {
	/a*b/.test(name); // NOT OK
};

const SubClass = require('./subclass');
module.exports.SubClass = new SubClass();
