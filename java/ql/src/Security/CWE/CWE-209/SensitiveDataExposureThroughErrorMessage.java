protected void doGet(HttpServletRequest request, HttpServletResponse response) {
	try {
		doSomeWork();
	} catch (NullPointerException ex) {
		// BAD: printing a exception message back to the response
		response.sendError(
			HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
			ex.getMessage());
		return;
	}

	try {
		doSomeWork();
	} catch (NullPointerException ex) {
		// GOOD: log the exception message, and send back a non-revealing response
		log("Exception occurred", ex.getMessage);
		response.sendError(
			HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
			"Exception occurred");
		return;
	}
}
