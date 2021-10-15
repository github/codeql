public class UnsafeAndroidAccess extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.webview);

		// BAD: Have both JavaScript and cross-origin resource access enabled in webview while
		// taking remote user inputs
		{
			WebView wv = (WebView) findViewById(R.id.my_webview);
			WebSettings webSettings = wv.getSettings();

			webSettings.setJavaScriptEnabled(true);
			webSettings.setAllowUniversalAccessFromFileURLs(true);

			wv.setWebViewClient(new WebViewClient() {
				@Override
				public boolean shouldOverrideUrlLoading(WebView view, String url) {
					view.loadUrl(url);
					return true;
				}
			});

			String thisUrl = getIntent().getExtras().getString("url"); // dangerous remote input from  the intent's Bundle of extras
			wv.loadUrl(thisUrl);
		}

		// BAD: Have both JavaScript and cross-origin resource access enabled in webview while
		// taking remote user inputs
		{
			WebView wv = (WebView) findViewById(R.id.my_webview);
			WebSettings webSettings = wv.getSettings();

			webSettings.setJavaScriptEnabled(true);
			webSettings.setAllowUniversalAccessFromFileURLs(true);

			wv.setWebViewClient(new WebViewClient() {
				@Override
				public boolean shouldOverrideUrlLoading(WebView view, String url) {
					view.loadUrl(url);
					return true;
				}
			});

			String thisUrl = getIntent().getStringExtra("url"); //dangerous remote input from intent extra
			wv.loadUrl(thisUrl);
		}

		// GOOD: Have JavaScript and cross-origin resource access disabled by default on modern Android (Jellybean+) while taking remote user inputs
		{
			WebView wv = (WebView) findViewById(-1);
			WebSettings webSettings = wv.getSettings();

			wv.setWebViewClient(new WebViewClient() {
				@Override
				public boolean shouldOverrideUrlLoading(WebView view, String url) {
					view.loadUrl(url);
					return true;
				}
			});

			String thisUrl = getIntent().getExtras().getString("url"); // remote input
			wv.loadUrl(thisUrl);
		}

		// GOOD: Have JavaScript enabled in webview but remote user input is not allowed
		{
			WebView wv = (WebView) findViewById(-1);
			WebSettings webSettings = wv.getSettings();

			webSettings.setJavaScriptEnabled(true);

			wv.setWebViewClient(new WebViewClient() {
				@Override
				public boolean shouldOverrideUrlLoading(WebView view, String url) {
					view.loadUrl(url);
					return true;
				}
			});

			wv.loadUrl("https://www.mycorp.com");
		}
	}
}