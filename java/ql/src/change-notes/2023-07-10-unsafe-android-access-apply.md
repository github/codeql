---
category: minorAnalysis
---
* The query "Unsafe resource fetching in Android WebView" (`java/android/unsafe-android-webview-fetch`) now recognizes WebViews where `setJavascriptEnabled`, `setAllowFileAccess`, `setAllowUniversalAccessFromFileURLs`, and/or `setAllowFileAccessFromFileURLs` are set inside the function block of the Kotlin `apply` function.
