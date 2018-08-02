var cache;

function init() {
	cache = {};
}

function done() {
	delete cache;
}

function get(k) {
	k = '$' + k;
	if (!cache.hasOwnProperty(k))
		cache[k] = compute(k);
	return cache[k];
}

function compute(k) {
	// compute value for k
	// ...
}