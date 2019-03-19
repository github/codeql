function anySatisfiers(arr) {
	var foundAnElement = false;
	
	arr.forEach(function (el) {
		if (predicate(el)) {
			foundAnElement = true;			
		}
	});
	
	return foundAnElement;
}