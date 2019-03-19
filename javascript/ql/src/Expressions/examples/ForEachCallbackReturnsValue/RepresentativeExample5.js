function anySatisfiers(arr)
	for (var el in arr) {
		if (predicate(el)) {
			return true;					
		}
	}
	
	return false;
}