Array.prototype.anySatisfiers = function (pred) {
	for (var i = 0; i < this.length; i++) {
		if (pred(this[i])) {
			return true;
		}
	}
	
	return false;
}

var foundAnElement = arr.anySatisfiers(pred);