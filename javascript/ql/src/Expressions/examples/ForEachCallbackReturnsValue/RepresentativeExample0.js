var foundAnElement = arr.forEach(function (el) {
	if (predicate(el)) {
		return true;					
	}
});