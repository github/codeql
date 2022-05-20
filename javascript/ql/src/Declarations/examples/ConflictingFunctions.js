function getConverter(dir) {
	if (dir === 'c2f') {
		function converter(c) {
			return c * 9/5 + 32;
		}
	} else {
		function converter(f) {
			return (f - 32) * 5/9;
		}
	}
	return converter;
}