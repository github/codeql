WebViewAssetLoader loader = new WebViewAssetLoader.Builder()
    // Replace the domain with a domain you control, or use the default
    // appassets.androidplatform.com
    .setDomain("appassets.example.com")
    .addPathHandler("/resources", new AssetsPathHandler(this))
    .build();

webView.setWebViewClient(new WebViewClientCompat() {
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        return assetLoader.shouldInterceptRequest(request.getUrl());
    }
});

webView.loadUrl("https://appassets.example.com/resources/www/index.html");
