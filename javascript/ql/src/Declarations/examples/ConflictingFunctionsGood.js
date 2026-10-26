function getConverter(dir) {
	var converter;
	if (dir === 'c2f') {
		converter = function (c) {
			return c * 9/5 + 32;
		};
	} else {
		converter = function (f) {
			return (f - 32) * 5/9;
		};
	}
	return converter;
}