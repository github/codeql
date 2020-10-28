package com.example.app;

import android.app.Activity;

import android.os.Bundle;

import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class UnsafeActivity4 extends Activity {
	/** 
	 * Test onCreate with both JavaScript and cross-origin resource access enabled while taking remote user inputs from bundle extras
     * Note this case of invoking utility method that takes an Activity a then calls `a.getIntent().getStringExtra(...)` is not yet detected thus is beyond what the query is capable of.
	 */
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		WebView wv = (WebView) findViewById(-1);
		WebSettings webSettings = wv.getSettings();

		webSettings.setJavaScriptEnabled(true);
		webSettings.setAllowFileAccessFromFileURLs(true);

		wv.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				view.loadUrl(url);
				return true;
			}
		});

		String thisUrl = IntentUtils.getIntentUrl(this);
		thisUrl = IntentUtils.getBundleUrl(this);
		wv.loadUrl(thisUrl);
	}
}