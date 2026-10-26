exports.require = function(special) {
	if (special) {
		return require("fs");
	} else {
		return require("original-fs");
	}
};
