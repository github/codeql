(function(global) {
	var cache;

	global.init = function init() {
		cache = {};
	};

	global.done = function done() {
	};

	global.get = function get(k) {
		k = '$' + k;
		if (!cache.hasOwnProperty(k))
			cache[k] = compute(k);
		return cache[k];
	}

	function compute(k) {
		// compute value for k
		// ...
	}
}(this));