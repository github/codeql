var foundAnElement = false;

arr.forEach(function (el) {
	if (predicate(el)) {
		foundAnElement = true;					
	}
});