/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package android.webkit;

import android.content.Context;
import android.content.Intent;

import java.io.File;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * A View that displays web pages. This class is the basis upon which you can
 * roll your own web browser or simply display some online content within your
 * Activity. It uses the WebKit rendering engine to display web pages and
 * includes methods to navigate forward and backward through a history, zoom in
 * and out, perform text searches and more.
 *
 * <p>
 * Note that, in order for your Activity to access the Internet and load web
 * pages in a WebView, you must add the {@code INTERNET} permissions to your
 * Android Manifest file:
 *
 * <pre>
 * {@code <uses-permission android:name="android.permission.INTERNET" />}
 * </pre>
 *
 * <p>
 * This must be a child of the <a href="
 * {@docRoot}guide/topics/manifest/manifest-element.html">{@code <manifest>}</a>
 * element.
 *
 * <p>
 * For more information, read
 * <a href="{@docRoot}guide/webapps/webview.html">Building Web Apps in
 * WebView</a>.
 *
 * <h3>Basic usage</h3>
 *
 * <p>
 * By default, a WebView provides no browser-like widgets, does not enable
 * JavaScript and web page errors are ignored. If your goal is only to display
 * some HTML as a part of your UI, this is probably fine; the user won't need to
 * interact with the web page beyond reading it, and the web page won't need to
 * interact with the user. If you actually want a full-blown web browser, then
 * you probably want to invoke the Browser application with a URL Intent rather
 * than show it with a WebView. For example:
 * 
 * <pre>
 * Uri uri = Uri.parse("https://www.example.com");
 * Intent intent = new Intent(Intent.ACTION_VIEW, uri);
 * startActivity(intent);
 * </pre>
 * <p>
 * See {@link android.content.Intent} for more information.
 *
 * <p>
 * To provide a WebView in your own Activity, include a {@code <WebView>} in
 * your layout, or set the entire Activity window as a WebView during
 * {@link android.app.Activity#onCreate(Bundle) onCreate()}:
 *
 * <pre class="prettyprint">
 * WebView webview = new WebView(this);
 * setContentView(webview);
 * </pre>
 *
 * <p>
 * Then load the desired web page:
 *
 * <pre>
 * // Simplest usage: note that an exception will NOT be thrown
 * // if there is an error loading this page (see below).
 * webview.loadUrl("https://example.com/");
 *
 * // OR, you can also load from an HTML string:
 * String summary = "&lt;html>&lt;body>You scored &lt;b>192&lt;/b> points.&lt;/body>&lt;/html>";
 * webview.loadData(summary, "text/html", null);
 * // ... although note that there are restrictions on what this HTML can do.
 * // See {@link #loadData(String,String,String)} and {@link
 * #loadDataWithBaseURL(String,String,String,String,String)} for more info.
 * // Also see {@link #loadData(String,String,String)} for information on encoding special
 * // characters.
 * </pre>
 *
 * <p>
 * A WebView has several customization points where you can add your own
 * behavior. These are:
 *
 * <ul>
 * <li>Creating and setting a {@link android.webkit.WebChromeClient} subclass.
 * This class is called when something that might impact a browser UI happens,
 * for instance, progress updates and JavaScript alerts are sent here (see
 * <a href="
 * {@docRoot}guide/developing/debug-tasks.html#DebuggingWebPages">Debugging
 * Tasks</a>).</li>
 * <li>Creating and setting a {@link android.webkit.WebViewClient} subclass. It
 * will be called when things happen that impact the rendering of the content,
 * eg, errors or form submissions. You can also intercept URL loading here (via
 * {@link android.webkit.WebViewClient#shouldOverrideUrlLoading(WebView,String)
 * shouldOverrideUrlLoading()}).</li>
 * <li>Modifying the {@link android.webkit.WebSettings}, such as enabling
 * JavaScript with
 * {@link android.webkit.WebSettings#setJavaScriptEnabled(boolean)
 * setJavaScriptEnabled()}.</li>
 * <li>Injecting Java objects into the WebView using the
 * {@link android.webkit.WebView#addJavascriptInterface} method. This method
 * allows you to inject Java objects into a page's JavaScript context, so that
 * they can be accessed by JavaScript in the page.</li>
 * </ul>
 *
 * <p>
 * Here's a more complicated example, showing error handling, settings, and
 * progress notification:
 *
 * <pre class="prettyprint">
 * // Let's display the progress in the activity title bar, like the
 * // browser app does.
 * getWindow().requestFeature(Window.FEATURE_PROGRESS);
 *
 * webview.getSettings().setJavaScriptEnabled(true);
 *
 * final Activity activity = this;
 * webview.setWebChromeClient(new WebChromeClient() {
 *     public void onProgressChanged(WebView view, int progress) {
 *         // Activities and WebViews measure progress with different scales.
 *         // The progress meter will automatically disappear when we reach 100%
 *         activity.setProgress(progress * 1000);
 *     }
 * });
 * webview.setWebViewClient(new WebViewClient() {
 *     public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
 *         Toast.makeText(activity, "Oh no! " + description, Toast.LENGTH_SHORT).show();
 *     }
 * });
 *
 * webview.loadUrl("https://developer.android.com/");
 * </pre>
 *
 * <h3>Zoom</h3>
 *
 * <p>
 * To enable the built-in zoom, set {@link #getSettings()
 * WebSettings}.{@link WebSettings#setBuiltInZoomControls(boolean)} (introduced
 * in API level {@link android.os.Build.VERSION_CODES#CUPCAKE}).
 *
 * <p class="note">
 * <b>Note:</b> Using zoom if either the height or width is set to
 * {@link android.view.ViewGroup.LayoutParams#WRAP_CONTENT} may lead to
 * undefined behavior and should be avoided.
 *
 * <h3>Cookie and window management</h3>
 *
 * <p>
 * For obvious security reasons, your application has its own cache, cookie
 * store etc.&mdash;it does not share the Browser application's data.
 *
 * <p>
 * By default, requests by the HTML to open new windows are ignored. This is
 * {@code true} whether they be opened by JavaScript or by the target attribute
 * on a link. You can customize your {@link WebChromeClient} to provide your own
 * behavior for opening multiple windows, and render them in whatever manner you
 * want.
 *
 * <p>
 * The standard behavior for an Activity is to be destroyed and recreated when
 * the device orientation or any other configuration changes. This will cause
 * the WebView to reload the current page. If you don't want that, you can set
 * your Activity to handle the {@code orientation} and {@code keyboardHidden}
 * changes, and then just leave the WebView alone. It'll automatically re-orient
 * itself as appropriate. Read
 * <a href="{@docRoot}guide/topics/resources/runtime-changes.html">Handling
 * Runtime Changes</a> for more information about how to handle configuration
 * changes during runtime.
 *
 *
 * <h3>Building web pages to support different screen densities</h3>
 *
 * <p>
 * The screen density of a device is based on the screen resolution. A screen
 * with low density has fewer available pixels per inch, where a screen with
 * high density has more &mdash; sometimes significantly more &mdash; pixels per
 * inch. The density of a screen is important because, other things being equal,
 * a UI element (such as a button) whose height and width are defined in terms
 * of screen pixels will appear larger on the lower density screen and smaller
 * on the higher density screen. For simplicity, Android collapses all actual
 * screen densities into three generalized densities: high, medium, and low.
 * <p>
 * By default, WebView scales a web page so that it is drawn at a size that
 * matches the default appearance on a medium density screen. So, it applies
 * 1.5x scaling on a high density screen (because its pixels are smaller) and
 * 0.75x scaling on a low density screen (because its pixels are bigger).
 * Starting with API level {@link android.os.Build.VERSION_CODES#ECLAIR},
 * WebView supports DOM, CSS, and meta tag features to help you (as a web
 * developer) target screens with different screen densities.
 * <p>
 * Here's a summary of the features you can use to handle different screen
 * densities:
 * <ul>
 * <li>The {@code window.devicePixelRatio} DOM property. The value of this
 * property specifies the default scaling factor used for the current device.
 * For example, if the value of {@code
 * window.devicePixelRatio} is "1.0", then the device is considered a medium
 * density (mdpi) device and default scaling is not applied to the web page; if
 * the value is "1.5", then the device is considered a high density device
 * (hdpi) and the page content is scaled 1.5x; if the value is "0.75", then the
 * device is considered a low density device (ldpi) and the content is scaled
 * 0.75x.</li>
 * <li>The {@code -webkit-device-pixel-ratio} CSS media query. Use this to
 * specify the screen densities for which this style sheet is to be used. The
 * corresponding value should be either "0.75", "1", or "1.5", to indicate that
 * the styles are for devices with low density, medium density, or high density
 * screens, respectively. For example:
 * 
 * <pre>
 * &lt;link rel="stylesheet" media="screen and (-webkit-device-pixel-ratio:1.5)" href="hdpi.css" /&gt;
 * </pre>
 * <p>
 * The {@code hdpi.css} stylesheet is only used for devices with a screen pixel
 * ratio of 1.5, which is the high density pixel ratio.</li>
 * </ul>
 *
 * <h3>HTML5 Video support</h3>
 *
 * <p>
 * In order to support inline HTML5 video in your application you need to have
 * hardware acceleration turned on.
 *
 * <h3>Full screen support</h3>
 *
 * <p>
 * In order to support full screen &mdash; for video or other HTML content
 * &mdash; you need to set a {@link android.webkit.WebChromeClient} and
 * implement both
 * {@link WebChromeClient#onShowCustomView(View, WebChromeClient.CustomViewCallback)}
 * and {@link WebChromeClient#onHideCustomView()}. If the implementation of
 * either of these two methods is missing then the web contents will not be
 * allowed to enter full screen. Optionally you can implement
 * {@link WebChromeClient#getVideoLoadingProgressView()} to customize the View
 * displayed whilst a video is loading.
 *
 * <h3>HTML5 Geolocation API support</h3>
 *
 * <p>
 * For applications targeting Android N and later releases (API level >
 * {@link android.os.Build.VERSION_CODES#M}) the geolocation api is only
 * supported on secure origins such as https. For such applications requests to
 * geolocation api on non-secure origins are automatically denied without
 * invoking the corresponding
 * {@link WebChromeClient#onGeolocationPermissionsShowPrompt(String, GeolocationPermissions.Callback)}
 * method.
 *
 * <h3>Layout size</h3>
 * <p>
 * It is recommended to set the WebView layout height to a fixed value or to
 * {@link android.view.ViewGroup.LayoutParams#MATCH_PARENT} instead of using
 * {@link android.view.ViewGroup.LayoutParams#WRAP_CONTENT}. When using
 * {@link android.view.ViewGroup.LayoutParams#MATCH_PARENT} for the height none
 * of the WebView's parents should use a
 * {@link android.view.ViewGroup.LayoutParams#WRAP_CONTENT} layout height since
 * that could result in incorrect sizing of the views.
 *
 * <p>
 * Setting the WebView's height to
 * {@link android.view.ViewGroup.LayoutParams#WRAP_CONTENT} enables the
 * following behaviors:
 * <ul>
 * <li>The HTML body layout height is set to a fixed value. This means that
 * elements with a height relative to the HTML body may not be sized correctly.
 * </li>
 * <li>For applications targeting {@link android.os.Build.VERSION_CODES#KITKAT}
 * and earlier SDKs the HTML viewport meta tag will be ignored in order to
 * preserve backwards compatibility.</li>
 * </ul>
 *
 * <p>
 * Using a layout width of
 * {@link android.view.ViewGroup.LayoutParams#WRAP_CONTENT} is not supported. If
 * such a width is used the WebView will attempt to use the width of the parent
 * instead.
 *
 * <h3>Metrics</h3>
 *
 * <p>
 * WebView may upload anonymous diagnostic data to Google when the user has
 * consented. This data helps Google improve WebView. Data is collected on a
 * per-app basis for each app which has instantiated a WebView. An individual
 * app can opt out of this feature by putting the following tag in its
 * manifest's {@code <application>} element:
 * 
 * <pre>
 * &lt;manifest&gt;
 *     &lt;application&gt;
 *         ...
 *         &lt;meta-data android:name=&quot;android.webkit.WebView.MetricsOptOut&quot;
 *             android:value=&quot;true&quot; /&gt;
 *     &lt;/application&gt;
 * &lt;/manifest&gt;
 * </pre>
 * <p>
 * Data will only be uploaded for a given app if the user has consented AND the
 * app has not opted out.
 *
 * <h3>Safe Browsing</h3>
 *
 * <p>
 * With Safe Browsing, WebView will block malicious URLs and present a warning
 * UI to the user to allow them to navigate back safely or proceed to the
 * malicious page.
 * <p>
 * Safe Browsing is enabled by default on devices which support it. If your app
 * needs to disable Safe Browsing for all WebViews, it can do so in the
 * manifest's {@code <application>} element:
 * <p>
 * 
 * <pre>
 * &lt;manifest&gt;
 *     &lt;application&gt;
 *         ...
 *         &lt;meta-data android:name=&quot;android.webkit.WebView.EnableSafeBrowsing&quot;
 *             android:value=&quot;false&quot; /&gt;
 *     &lt;/application&gt;
 * &lt;/manifest&gt;
 * </pre>
 *
 * <p>
 * Otherwise, see {@link WebSettings#setSafeBrowsingEnabled}.
 *
 */
// Implementation notes.
// The WebView is a thin API class that delegates its public API to a backend
// WebViewProvider
// class instance. WebView extends {@link AbsoluteLayout} for backward
// compatibility reasons.
// Methods are delegated to the provider implementation: all public API methods
// introduced in this
// file are fully delegated, whereas public and protected methods from the View
// base classes are
// only delegated where a specific need exists for them to do so.
public class WebView {

    /**
     * Constructs a new WebView with an Activity Context object.
     *
     * <p class="note">
     * <b>Note:</b> WebView should always be instantiated with an Activity Context.
     * If instantiated with an Application Context, WebView will be unable to
     * provide several features, such as JavaScript dialogs and autofill.
     *
     * @param context an Activity Context to access application assets
     */
    public WebView(Context context) {
    }

    /**
     * Loads the given URL with the specified additional HTTP headers.
     * <p>
     * Also see compatibility note on {@link #evaluateJavascript}.
     *
     * @param url                   the URL of the resource to load
     * @param additionalHttpHeaders the additional headers to be used in the HTTP
     *                              request for this URL, specified as a map from
     *                              name to value. Note that if this map contains
     *                              any of the headers that are set by default by
     *                              this WebView, such as those controlling caching,
     *                              accept types or the User-Agent, their values may
     *                              be overridden by this WebView's defaults.
     */
    public void loadUrl(String url, Map<String, String> additionalHttpHeaders) {
    }

    /**
     * Loads the given URL.
     * <p>
     * Also see compatibility note on {@link #evaluateJavascript}.
     *
     * @param url the URL of the resource to load
     */
    public void loadUrl(String url) {
    }

    /**
     * Loads the URL with postData using "POST" method into this WebView. If url is
     * not a network URL, it will be loaded with {@link #loadUrl(String)} instead,
     * ignoring the postData param.
     *
     * @param url      the URL of the resource to load
     * @param postData the data will be passed to "POST" request, which must be be
     *                 "application/x-www-form-urlencoded" encoded.
     */
    public void postUrl(String url, byte[] postData) {
    }

    /**
     * Loads the given data into this WebView using a 'data' scheme URL.
     * <p>
     * Note that JavaScript's same origin policy means that script running in a page
     * loaded using this method will be unable to access content loaded using any
     * scheme other than 'data', including 'http(s)'. To avoid this restriction, use
     * {@link #loadDataWithBaseURL(String,String,String,String,String)
     * loadDataWithBaseURL()} with an appropriate base URL.
     * <p>
     * The {@code encoding} parameter specifies whether the data is base64 or URL
     * encoded. If the data is base64 encoded, the value of the encoding parameter
     * must be 'base64'. HTML can be encoded with
     * {@link android.util.Base64#encodeToString(byte[],int)} like so:
     * 
     * <pre>
     * String unencodedHtml = "&lt;html&gt;&lt;body&gt;'%28' is the code for '('&lt;/body&gt;&lt;/html&gt;";
     * String encodedHtml = Base64.encodeToString(unencodedHtml.getBytes(), Base64.NO_PADDING);
     * webView.loadData(encodedHtml, "text/html", "base64");
     * </pre>
     * <p>
     * For all other values of {@code encoding} (including {@code null}) it is
     * assumed that the data uses ASCII encoding for octets inside the range of safe
     * URL characters and use the standard %xx hex encoding of URLs for octets
     * outside that range. See
     * <a href="https://tools.ietf.org/html/rfc3986#section-2.2">RFC 3986</a> for
     * more information.
     * <p>
     * The {@code mimeType} parameter specifies the format of the data. If WebView
     * can't handle the specified MIME type, it will download the data. If
     * {@code null}, defaults to 'text/html'.
     * <p>
     * The 'data' scheme URL formed by this method uses the default US-ASCII
     * charset. If you need to set a different charset, you should form a 'data'
     * scheme URL which explicitly specifies a charset parameter in the mediatype
     * portion of the URL and call {@link #loadUrl(String)} instead. Note that the
     * charset obtained from the mediatype portion of a data URL always overrides
     * that specified in the HTML or XML document itself.
     * <p>
     * Content loaded using this method will have a {@code window.origin} value of
     * {@code "null"}. This must not be considered to be a trusted origin by the
     * application or by any JavaScript code running inside the WebView (for
     * example, event sources in DOM event handlers or web messages), because
     * malicious content can also create frames with a null origin. If you need to
     * identify the main frame's origin in a trustworthy way, you should use
     * {@link #loadDataWithBaseURL(String,String,String,String,String)
     * loadDataWithBaseURL()} with a valid HTTP or HTTPS base URL to set the origin.
     *
     * @param data     a String of data in the given encoding
     * @param mimeType the MIME type of the data, e.g. 'text/html'.
     * @param encoding the encoding of the data
     */
    public void loadData(String data, String mimeType, String encoding) {
    }

    /**
     * Loads the given data into this WebView, using baseUrl as the base URL for the
     * content. The base URL is used both to resolve relative URLs and when applying
     * JavaScript's same origin policy. The historyUrl is used for the history
     * entry.
     * <p>
     * The {@code mimeType} parameter specifies the format of the data. If WebView
     * can't handle the specified MIME type, it will download the data. If
     * {@code null}, defaults to 'text/html'.
     * <p>
     * Note that content specified in this way can access local device files (via
     * 'file' scheme URLs) only if baseUrl specifies a scheme other than 'http',
     * 'https', 'ftp', 'ftps', 'about' or 'javascript'.
     * <p>
     * If the base URL uses the data scheme, this method is equivalent to calling
     * {@link #loadData(String,String,String) loadData()} and the historyUrl is
     * ignored, and the data will be treated as part of a data: URL. If the base URL
     * uses any other scheme, then the data will be loaded into the WebView as a
     * plain string (i.e. not part of a data URL) and any URL-encoded entities in
     * the string will not be decoded.
     * <p>
     * Note that the baseUrl is sent in the 'Referer' HTTP header when requesting
     * subresources (images, etc.) of the page loaded using this method.
     * <p>
     * If a valid HTTP or HTTPS base URL is not specified in {@code baseUrl}, then
     * content loaded using this method will have a {@code window.origin} value of
     * {@code "null"}. This must not be considered to be a trusted origin by the
     * application or by any JavaScript code running inside the WebView (for
     * example, event sources in DOM event handlers or web messages), because
     * malicious content can also create frames with a null origin. If you need to
     * identify the main frame's origin in a trustworthy way, you should use a valid
     * HTTP or HTTPS base URL to set the origin.
     *
     * @param baseUrl    the URL to use as the page's base URL. If {@code null}
     *                   defaults to 'about:blank'.
     * @param data       a String of data in the given encoding
     * @param mimeType   the MIME type of the data, e.g. 'text/html'.
     * @param encoding   the encoding of the data
     * @param historyUrl the URL to use as the history entry. If {@code null}
     *                   defaults to 'about:blank'. If non-null, this must be a
     *                   valid URL.
     */
    public void loadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String historyUrl) {
    }

        /**
     * Sets the WebViewClient that will receive various notifications and
     * requests. This will replace the current handler.
     *
     * @param client an implementation of WebViewClient
     * @see #getWebViewClient
     */
    public void setWebViewClient(WebViewClient client) {
    }
    /**
     * Gets the WebViewClient.
     *
     * @return the WebViewClient, or a default client if not yet set
     * @see #setWebViewClient
     */
    public WebViewClient getWebViewClient() {
        return null;
    }

    /**
     * Injects the supplied Java object into this WebView. The object is
     * injected into the JavaScript context of the main frame, using the
     * supplied name. This allows the Java object's methods to be
     * accessed from JavaScript. For applications targeted to API
     * level {@link android.os.Build.VERSION_CODES#JELLY_BEAN_MR1}
     * and above, only public methods that are annotated with
     * {@link android.webkit.JavascriptInterface} can be accessed from JavaScript.
     * For applications targeted to API level {@link android.os.Build.VERSION_CODES#JELLY_BEAN} or below,
     * all public methods (including the inherited ones) can be accessed, see the
     * important security note below for implications.
     * <p> Note that injected objects will not appear in JavaScript until the page is next
     * (re)loaded. JavaScript should be enabled before injecting the object. For example:
     * <pre>
     * class JsObject {
     *    {@literal @}JavascriptInterface
     *    public String toString() { return "injectedObject"; }
     * }
     * webview.getSettings().setJavaScriptEnabled(true);
     * webView.addJavascriptInterface(new JsObject(), "injectedObject");
     * webView.loadData("<!DOCTYPE html><title></title>", "text/html", null);
     * webView.loadUrl("javascript:alert(injectedObject.toString())");</pre>
     * <p>
     * <strong>IMPORTANT:</strong>
     * <ul>
     * <li> This method can be used to allow JavaScript to control the host
     * application. This is a powerful feature, but also presents a security
     * risk for apps targeting {@link android.os.Build.VERSION_CODES#JELLY_BEAN} or earlier.
     * Apps that target a version later than {@link android.os.Build.VERSION_CODES#JELLY_BEAN}
     * are still vulnerable if the app runs on a device running Android earlier than 4.2.
     * The most secure way to use this method is to target {@link android.os.Build.VERSION_CODES#JELLY_BEAN_MR1}
     * and to ensure the method is called only when running on Android 4.2 or later.
     * With these older versions, JavaScript could use reflection to access an
     * injected object's public fields. Use of this method in a WebView
     * containing untrusted content could allow an attacker to manipulate the
     * host application in unintended ways, executing Java code with the
     * permissions of the host application. Use extreme care when using this
     * method in a WebView which could contain untrusted content.</li>
     * <li> JavaScript interacts with Java object on a private, background
     * thread of this WebView. Care is therefore required to maintain thread
     * safety.
     * </li>
     * <li> The Java object's fields are not accessible.</li>
     * <li> For applications targeted to API level {@link android.os.Build.VERSION_CODES#LOLLIPOP}
     * and above, methods of injected Java objects are enumerable from
     * JavaScript.</li>
     * </ul>
     *
     * @param object the Java object to inject into this WebView's JavaScript
     *               context. {@code null} values are ignored.
     * @param name the name used to expose the object in JavaScript
     */
    public void addJavascriptInterface(Object object, String name) {
    }
    /**
     * Removes a previously injected Java object from this WebView. Note that
     * the removal will not be reflected in JavaScript until the page is next
     * (re)loaded. See {@link #addJavascriptInterface}.
     *
     * @param name the name used to expose the object in JavaScript
     */
    public void removeJavascriptInterface(String name) {
    }

    /**
     * Gets the WebSettings object used to control the settings for this
     * WebView.
     *
     * @return a WebSettings object that can be used to control this WebView's
     *         settings
     */
    public WebSettings getSettings() {
        return null;
    }



}
