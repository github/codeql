(function(module) {
	var me = {};
	Object.defineProperty(me, 'tricky', 56);
	module.exports = me;
}(module));

require("process"); // ensure this is treated as Node.js code
