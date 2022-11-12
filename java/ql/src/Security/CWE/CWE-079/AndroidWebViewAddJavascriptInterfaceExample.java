class ExposedObject {
    @JavascriptInterface
    public String example() {
        return "String from Java";
    }
}

webview.getSettings().setJavaScriptEnabled(true);
webview.addJavaScriptInterface(new ExposedObject(), "exposedObject");
webview.loadData("", "text/html", null);
webview.loadUrl("javascript:alert(exposedObject.example())");
