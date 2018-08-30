public static void test(HttpServletRequest request, HttpServletResponse response) {
	{
		Cookie cookie = new Cookie("secret", "fakesecret");
		
		// BAD: 'secure' flag not set
		response.addCookie(cookie);
	}

	{
		Cookie cookie = new Cookie("secret", "fakesecret");
		
		// GOOD: set 'secure' flag
		cookie.setSecure(true);
		response.addCookie(cookie);
	}
}