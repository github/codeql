function anySatisfiers(arr) {
	arr.forEach(function (el) {
		if (predicate(el)) {
			return true;
		}
	});
	
	return false;
}