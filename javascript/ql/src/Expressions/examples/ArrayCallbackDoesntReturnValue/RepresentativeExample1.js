var arr2 = arr.map(function (el) {
	if (pred(el)) {
		return purify(el);				
	} else {
		return el;
	}
});