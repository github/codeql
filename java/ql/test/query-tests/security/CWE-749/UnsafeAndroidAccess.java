package com.example.app;

import android.app.Activity;

import android.os.Bundle;

import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

// The Activity is implicitly exported because it has an intent-filter.
public class UnsafeAndroidAccess extends Activity {
	// Test onCreate with both JavaScript and cross-origin resource access enabled while taking
	// remote user inputs from bundle extras
	public void testOnCreate1(Bundle savedInstanceState) {
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
		wv.loadUrl(thisUrl); // $hasUnsafeAndroidAccess
	}

	// Test onCreate with both JavaScript and cross-origin resource access enabled while taking
	// remote user inputs from string extra
	public void testOnCreate2(Bundle savedInstanceState) {
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

		String thisUrl = getIntent().getStringExtra("url");
		wv.loadUrl(thisUrl); // $hasUnsafeAndroidAccess
	}

	// Test onCreate with both JavaScript and cross-origin resource access disabled by default while
	// taking remote user inputs
	public void testOnCreate3(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

		WebView wv = (WebView) findViewById(-1);
		WebSettings webSettings = wv.getSettings();

		wv.setWebViewClient(new WebViewClient() {
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				view.loadUrl(url);
				return true;
			}
		});

		String thisUrl = getIntent().getStringExtra("url");
		wv.loadUrl(thisUrl); // Safe
	}

	// Test onCreate with JavaScript enabled but cross-origin resource access disabled while taking
	// remote user inputs
	public void testOnCreate4(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(-1);

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

		String thisUrl = getIntent().getStringExtra("url");
		wv.loadUrl(thisUrl); // $hasUnsafeAndroidAccess
	}

	// Test onCreate with both JavaScript and cross-origin resource access enabled while not taking
	// remote user inputs
	public void testOnCreate5(Bundle savedInstanceState) {
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

		wv.loadUrl("https://www.mycorp.com"); // Safe
	}

	// Test onCreate with both JavaScript and cross-origin resource access enabled while taking
	// remote user inputs and concatenating them to a safe URL.
	public void testOnCreate6(Bundle savedInstanceState) {
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

		String thisUrl = getIntent().getStringExtra("url");
		wv.loadUrl("https://www.mycorp.com/" + thisUrl); // Safe
	}
}
