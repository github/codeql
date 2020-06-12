public class UnsafeAndroidAccess extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.webview);

		// BAD: Have both JavaScript and universal resource access enabled in webview while
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

			String thisUrl = getIntent().getExtras().getString("url"); // dangerous remote input
			//String thisUrl = getIntent().getStringExtra("url"); //An alternative way to load dangerous remote input
			wv.loadUrl(thisUrl);
		}

		// GOOD: Have JavaScript and universal resource access disabled while taking
		// remote user inputs
		{
			WebView wv = (WebView) findViewById(-1);
			WebSettings webSettings = wv.getSettings();

			webSettings.setJavaScriptEnabled(false);

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