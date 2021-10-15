var resource;
try {
	resource = acquire();
	if (someCond())
		throw new Error();
	performAction(resource);
} finally {
	resource.release();
	if (someOtherCond())
		return true;
}