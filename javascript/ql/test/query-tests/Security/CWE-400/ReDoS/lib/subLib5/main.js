module.exports = function (name) { // $ Source[js/polynomial-redos]
	/a*b/.test(name); // $ Alert[js/polynomial-redos]
};

const SubClass = require('./subclass');
module.exports.SubClass = new SubClass();
