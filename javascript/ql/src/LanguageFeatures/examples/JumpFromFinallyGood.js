var resource;
try {
	resource = acquire();
	if (someCond()) {
		if (someOtherCond())
			return true;
		else
			throw new Error();
	}
	performAction(resource);
	if (someOtherCond())
		return true;
} finally {
	resource.release();
}