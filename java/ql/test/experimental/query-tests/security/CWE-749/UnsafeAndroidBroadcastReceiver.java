package com.example.app;

import android.app.Activity;

import android.content.Context;
import android.content.Intent;
import android.content.BroadcastReceiver;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class UnsafeAndroidBroadcastReceiver extends BroadcastReceiver {
	//Test onCreate with JavaScript enabled but cross-origin resource access disabled while taking remote user inputs
	@Override
	public void onReceive(Context context, Intent intent) {
		String thisUrl = intent.getStringExtra("url");
		WebView wv = null;
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

		wv.loadUrl(thisUrl);
	}
}