function foo(resource) {
	try {
		if (checkCondition())
			throw new Error();
	} finally {
		resource.close();
		return true;
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
			break;
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