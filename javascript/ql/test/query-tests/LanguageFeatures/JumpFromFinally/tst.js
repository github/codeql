function foo(resource) {
	try {
		if (checkCondition())
			throw new Error();
	} finally {
		resource.close();
		return true; // $ Alert
	}
}

function bar(resource) {
	try {
		if (checkCondition())
			throw new Error();
	} finally {
		resource.close();
		(function(){return true;}());
	}
}

function baz(resource) {
	while (true) {
		try {
			if (checkCondition())
				throw new Error();
		} finally {
			resource.close();
			break; // $ Alert
		}
	}
}

function qux(resource) {
	try {
		if (checkCondition())
			throw new Error();
	} finally {
		resource.close();
		while(true)
			break;
	}
}