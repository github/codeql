public boolean shouldOverrideUrlLoading(WebView view, String url) {
    {
        Uri uri = Uri.parse(url);
        // BAD: partial domain match, which allows an attacker to register a domain like myexample.com to circumvent the verification
        if (uri.getHost() != null && uri.getHost().endsWith("example.com")) {
            return false;
        }
    }

    {
        Uri uri = Uri.parse(url);
        // GOOD: full domain match
        if (uri.getHost() != null && uri.getHost().endsWith(".example.com")) {
            return false;
        }
    }
}
