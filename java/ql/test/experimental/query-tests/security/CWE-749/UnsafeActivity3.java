package com.example.app;

import android.app.Activity;

import android.os.Bundle;

import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class UnsafeActivity3 extends Activity {
	//Test onCreate with both JavaScript and cross-origin resource access enabled while taking remote user inputs from bundle extras
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

		String thisUrl = getIntent().getExtras().getString("url");
		wv.loadUrl(thisUrl);
	}
}