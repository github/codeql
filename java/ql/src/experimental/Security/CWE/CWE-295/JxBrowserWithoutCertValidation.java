public static void main(String[] args) {
	{
		Browser browser = new Browser();
		browser.loadURL("https://example.com");
		// no further calls
		// BAD: The browser ignores any certificate error by default!
	}

	{
		Browser browser = new Browser();
		browser.setLoadHandler(new LoadHandler() {
			public boolean onLoad(LoadParams params) {
				return true;
			}

			public boolean onCertificateError(CertificateErrorParams params){
				return true; // GOOD: This means that loading will be cancelled on certificate errors
			}
		}); // GOOD: A secure `LoadHandler` is used.
		browser.loadURL("https://example.com");

	}
}