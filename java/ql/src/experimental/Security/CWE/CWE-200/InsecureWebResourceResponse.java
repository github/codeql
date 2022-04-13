// BAD: no URI validation
Uri uri = Uri.parse(url);
FileInputStream inputStream = new FileInputStream(uri.getPath());
String mimeType = getMimeTypeFromPath(uri.getPath());
return new WebResourceResponse(mimeType, "UTF-8", inputStream);


// GOOD: check for a trusted prefix, ensuring path traversal is not used to erase that prefix:
// (alternatively use `WebViewAssetsLoader`)
if (uri.getPath().startsWith("/local_cache/") && !uri.getPath().contains("..")) {
    File cacheFile = new File(getCacheDir(), uri.getLastPathSegment());
    FileInputStream inputStream = new FileInputStream(cacheFile);
    String mimeType = getMimeTypeFromPath(uri.getPath());
    return new WebResourceResponse(mimeType, "UTF-8", inputStream);
}

return assetLoader.shouldInterceptRequest(request.getUrl());
