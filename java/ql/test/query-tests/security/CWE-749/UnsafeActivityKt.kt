package com.example.app

import android.app.Activity
import android.os.Bundle
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient

class UnsafeActivityKt : Activity() {
    override fun onCreate(savedInstanceState : Bundle) {

		val src : String = intent.extras.getString("url")

		val wv = findViewById<WebView>(-1)
		// Implicit not-nulls happening here
		wv.settings.setJavaScriptEnabled(true)
		wv.settings.setAllowFileAccessFromFileURLs(true)

		wv.loadUrl(src) // $ hasUnsafeAndroidAccess

		val wv2 = findViewById<WebView>(-1)
		wv2.apply {
			settings.setJavaScriptEnabled(true)
		}
		wv2.loadUrl(src) // $ hasUnsafeAndroidAccess
    }
}
