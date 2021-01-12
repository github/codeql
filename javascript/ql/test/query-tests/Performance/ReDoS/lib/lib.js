var regexp = /a*b/;

module.exports = function (name) {
	regexp.test(name); // NOT OK
};
