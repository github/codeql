package app;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import com.android.internal.R;

public class UnsafeAndroidAccess extends Activity {
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.webview);
		testJavaScriptEnabledWebView();
		testCrossOriginEnabledWebView();
		testSafeWebView();
	}

	private void testJavaScriptEnabledWebView() {
		WebView wv = (WebView) findViewById(R.id.my_webview);
		WebSettings webSettings = wv.getSettings();

		webSettings.setJavaScriptEnabled(true);

		wv.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				view.loadUrl(url);
				return true;
			}
		});

		String thisUrl = getIntent().getExtras().getString("url");
		wv.loadUrl(thisUrl); // $hasUnsafeAndroidAccess
		wv.loadUrl("https://www.mycorp.com/" + thisUrl); // Safe
		wv.loadUrl("https://www.mycorp.com"); // Safe
	}

	private void testCrossOriginEnabledWebView() {
		WebView wv = (WebView) findViewById(R.id.my_webview);
		WebSettings webSettings = wv.getSettings();
		webSettings.setAllowUniversalAccessFromFileURLs(true);

		wv.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				view.loadUrl(url);
				return true;
			}
		});

		String thisUrl = getIntent().getStringExtra("url");
		wv.loadUrl(thisUrl); // $hasUnsafeAndroidAccess
		wv.loadUrl("https://www.mycorp.com/" + thisUrl); // Safe
		wv.loadUrl("https://www.mycorp.com"); // Safe
	}

	private void testSafeWebView() {
		WebView wv = (WebView) findViewById(-1);

		wv.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				view.loadUrl(url);
				return true;
			}
		});

		String thisUrl = getIntent().getExtras().getString("url");
		wv.loadUrl(thisUrl); // Safe
		wv.loadUrl("https://www.mycorp.com/" + thisUrl); // Safe
		wv.loadUrl("https://www.mycorp.com"); // Safe
	}
}