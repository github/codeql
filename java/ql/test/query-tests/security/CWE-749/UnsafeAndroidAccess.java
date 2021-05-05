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

			String thisUrl = getIntent().getExtras().getString("url");
			wv.loadUrl(thisUrl); // hasUnsafeAndroidAccess
		}

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

			String thisUrl = getIntent().getStringExtra("url");
			wv.loadUrl(thisUrl); // hasUnsafeAndroidAccess
		}

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
			wv.loadUrl(thisUrl); // Safe
		}

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

			wv.loadUrl("https://www.mycorp.com"); // Safe
		}
	}

}