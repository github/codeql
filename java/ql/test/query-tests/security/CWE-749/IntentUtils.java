package com.example.app;

import android.app.Activity;

import android.os.Bundle;

import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/** A utility program for getting intent extra information from Android activity */
public class IntentUtils {
	/** Get intent extra */
	public static String getIntentUrl(Activity a) {
		String thisUrl = a.getIntent().getStringExtra("url");
		return thisUrl;
	}

	/** Get bundle extra */
	public static String getBundleUrl(Activity a) {
		String thisUrl = a.getIntent().getExtras().getString("url");
		return thisUrl;
	}
}