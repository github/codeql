package com.example.app;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.IOException;
import java.util.Locale;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import android.webkit.MimeTypeMap;
import android.webkit.WebResourceRequest;
import android.webkit.WebView;
import androidx.webkit.WebViewAssetLoader;
import androidx.webkit.WebViewAssetLoader.AssetsPathHandler;
import android.webkit.WebViewClient;
import android.webkit.WebResourceResponse;

/** Insecure activity with its subclassed webviewclient implementation. */
public class InsecureWebResourceResponse extends Activity {
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(-1);

        String inputUrl = getIntent().getStringExtra("inputUrl");

        getBadResponse1(inputUrl);

        getBadResponse2(inputUrl);

        getBadResponse3(inputUrl);

        getGoodResponse4(inputUrl);

        getGoodResponse5(inputUrl);

        getBadResponse6(inputUrl);

        getBadResponse7(inputUrl);

        getGoodResponse8(inputUrl);
    }

    public static String getMimeTypeFromPath(String path) {
        String extension = path;
        int lastDot = extension.lastIndexOf('.');
        if (lastDot != -1) {
            extension = extension.substring(lastDot + 1);
        }

        extension = extension.toLowerCase(Locale.getDefault());
        return MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
    }

    // BAD: Return file of input path in annonyous WebViewClient without validation
    private void getBadResponse1(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                try {
                    Uri uri = Uri.parse(url);
                    FileInputStream inputStream = new FileInputStream(uri.getPath());
                    String mimeType = getMimeTypeFromPath(uri.getPath());
                    return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });

        wv.loadUrl(url);
    }

    // BAD: Return file of input path in annonyous WebViewClient with insufficient validation
    // A malicious input such as https://any.domain/local_cache/..%2Fshared_prefs/auth.xml can bypass the validation
    private void getBadResponse2(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                try {
                    Uri uri = Uri.parse(url);
                    if (uri.getPath().startsWith("/local_cache/")) {
                        File cacheFile = new File(getCacheDir(), uri.getLastPathSegment());
                        FileInputStream inputStream = new FileInputStream(cacheFile);
                        String mimeType = getMimeTypeFromPath(uri.getPath());
                        return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                    } else {
                        return new WebResourceResponse("text/plain", "UTF-8", null);
                    }
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });

        wv.loadUrl(url);
    }

    // BAD: Return file of input path in annonyous WebViewClient with insufficient validation
    // A malicious input such as https://any.domain/files/..%2Fshared_prefs/auth.xml can bypass the validation
    private void getBadResponse3(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                try {
                    Uri uri = Uri.parse(url);
                    String path = uri.getPath().substring(1);
                    if (path.startsWith("files/")) {
                        FileInputStream inputStream = new FileInputStream(path.substring("files/".length()));
                        String mimeType = getMimeTypeFromPath(uri.getPath());
                        return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                    } else {
                        return new WebResourceResponse("text/plain", "UTF-8", null);
                    }
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });

        wv.loadUrl(url);
    }

    // GOOD: Return file of input path in annonyous WebViewClient with sufficient validation
     private void getGoodResponse4(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                try {
                    Uri uri = Uri.parse(url);
                    if (uri.getPath().startsWith("/local_cache/") && !uri.getPath().contains("..")) {
                        File cacheFile = new File(getCacheDir(), uri.getLastPathSegment());
                        FileInputStream inputStream = new FileInputStream(cacheFile);
                        String mimeType = getMimeTypeFromPath(uri.getPath());
                        return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                    } else {
                        return new WebResourceResponse("text/plain", "UTF-8", null);
                    }
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });

        wv.loadUrl(url);
    }

    // GOOD: Return file of input path in annonyous WebViewClient with sufficient validation
    private void getGoodResponse5(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                try {
                    Uri uri = Uri.parse(url);
                    String path = uri.getPath().substring(1);
                    if (path.startsWith("files/")  && !path.contains("..")) {
                        FileInputStream inputStream = new FileInputStream(path.substring("files/".length()));
                        String mimeType = getMimeTypeFromPath(uri.getPath());
                        return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                    } else {
                        return new WebResourceResponse("text/plain", "UTF-8", null);
                    }
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });

        wv.loadUrl(url);
    }

    // BAD: Return file of input path in standalone WebViewClient without validation
    private void getBadResponse6(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new VulnerableWebViewClient());
        wv.loadUrl(url);
    }

    // BAD: Return file of input path in annonyous WebViewClient with insufficient validation using WebResourceRequest object
    private void getBadResponse7(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
                try {
                    Uri uri = request.getUrl();
                    if (uri.getPath().startsWith("/local_cache/")) {
                        File cacheFile = new File(getCacheDir(), uri.getLastPathSegment());
                        FileInputStream inputStream = new FileInputStream(cacheFile);
                        String mimeType = getMimeTypeFromPath(uri.getPath());
                        return new WebResourceResponse(mimeType, "UTF-8", inputStream);
                    } else {
                        return new WebResourceResponse("text/plain", "UTF-8", null);
                    }
                } catch (IOException ie) {
                    return new WebResourceResponse("text/plain", "UTF-8", null);
                }
            }
        });

        wv.loadUrl(url);
    }

    final WebViewAssetLoader assetLoader = new WebViewAssetLoader.Builder()
            .addPathHandler("/assets/", new AssetsPathHandler(this))
            .build();
   
    // GOOD: Return file of input path in annonyous WebViewClient with WebViewAssetLoader
    private void getGoodResponse8(String url) {
        WebView wv = (WebView) findViewById(-1);
        wv.setWebViewClient(new WebViewClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
                return assetLoader.shouldInterceptRequest(request.getUrl());
            }
        });

        wv.loadUrl(url);
    }
}

class VulnerableWebViewClient extends WebViewClient {
    @Override
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        try {
            Uri uri = Uri.parse(url);
            FileInputStream inputStream = new FileInputStream(uri.getPath());
            String mimeType = InsecureWebResourceResponse.getMimeTypeFromPath(uri.getPath());
            return new WebResourceResponse(mimeType, "UTF-8", inputStream);
        } catch (IOException ie) {
            return new WebResourceResponse("text/plain", "UTF-8", null);
        }
    }
}
