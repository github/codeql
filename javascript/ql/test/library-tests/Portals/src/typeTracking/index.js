function NP(exec) {
	this.exec = exec
}

function tempObj() {
}

tempObj.prototype.f = function(someCallback) {
	someCallback();
};

NP.prototype.createNP = function() {
	return new tempObj();
};

NP.prototype.argFunc = function(someCallback) {
	someCallback();
}

exports.NP = NP;