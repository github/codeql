function f(x) {
	switch (x.type) {
	case 'String':
		var value = x.value;
		return +value.trim();
	case 'Integer':
		var value = x.value;
		return value%2;
	}
}