package com.example.app

import android.app.Activity
import android.os.Bundle
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient

class UnsafeActivityKt : Activity() {
    override fun onCreate(savedInstanceState : Bundle) {

		val wv = findViewById<WebView>(-1)
		// Implicit not-nulls happening here
		wv.settings.setJavaScriptEnabled(true)
		wv.settings.setAllowFileAccessFromFileURLs(true)

		val thisUrl : String = intent.extras.getString("url")
		wv.loadUrl(thisUrl) // $ hasUnsafeAndroidAccess
    }
}
