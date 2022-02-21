/*
 * Copyright (C) 2008 The Android Open Source Project
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

public class WebViewClient {
    /**
     * Give the host application a chance to take over the control when a new url is
     * about to be loaded in the current WebView. If WebViewClient is not provided,
     * by default WebView will ask Activity Manager to choose the proper handler for
     * the url. If WebViewClient is provided, return {@code true} means the host
     * application handles the url, while return {@code false} means the current
     * WebView handles the url. This method is not called for requests using the
     * POST "method".
     *
     * @param view The WebView that is initiating the callback.
     * @param url  The url to be loaded.
     * @return {@code true} if the host application wants to leave the current
     *         WebView and handle the url itself, otherwise return {@code false}.
     * @deprecated Use {@link #shouldOverrideUrlLoading(WebView, WebResourceRequest)
     *             shouldOverrideUrlLoading(WebView, WebResourceRequest)} instead.
     */
    @Deprecated
    public boolean shouldOverrideUrlLoading(WebView view, String url) {
        return false;
    }

    /**
     * Give the host application a chance to take over the control when a new url is
     * about to be loaded in the current WebView. If WebViewClient is not provided,
     * by default WebView will ask Activity Manager to choose the proper handler for
     * the url. If WebViewClient is provided, return {@code true} means the host
     * application handles the url, while return {@code false} means the current
     * WebView handles the url.
     *
     * <p>
     * Notes:
     * <ul>
     * <li>This method is not called for requests using the POST
     * &quot;method&quot;.</li>
     * <li>This method is also called for subframes with non-http schemes, thus it
     * is strongly disadvised to unconditionally call
     * {@link WebView#loadUrl(String)} with the request's url from inside the method
     * and then return {@code true}, as this will make WebView to attempt loading a
     * non-http url, and thus fail.</li>
     * </ul>
     *
     * @param view    The WebView that is initiating the callback.
     * @param request Object containing the details of the request.
     * @return {@code true} if the host application wants to leave the current
     *         WebView and handle the url itself, otherwise return {@code false}.
     */
    public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request) {
        return false;
    }

    /**
     * Notify the host application that a page has finished loading. This method is
     * called only for main frame. When onPageFinished() is called, the rendering
     * picture may not be updated yet. To get the notification for the new Picture,
     * use {@link WebView.PictureListener#onNewPicture}.
     *
     * @param view The WebView that is initiating the callback.
     * @param url  The url of the page.
     */
    public void onPageFinished(WebView view, String url) {
    }

    /**
     * Notify the host application that the WebView will load the resource specified
     * by the given url.
     *
     * @param view The WebView that is initiating the callback.
     * @param url  The url of the resource the WebView will load.
     */
    public void onLoadResource(WebView view, String url) {
    }

    /**
     * Notify the host application that {@link android.webkit.WebView} content left
     * over from previous page navigations will no longer be drawn.
     *
     * <p>
     * This callback can be used to determine the point at which it is safe to make
     * a recycled {@link android.webkit.WebView} visible, ensuring that no stale
     * content is shown. It is called at the earliest point at which it can be
     * guaranteed that {@link WebView#onDraw} will no longer draw any content from
     * previous navigations. The next draw will display either the
     * {@link WebView#setBackgroundColor background color} of the {@link WebView},
     * or some of the contents of the newly loaded page.
     *
     * <p>
     * This method is called when the body of the HTTP response has started loading,
     * is reflected in the DOM, and will be visible in subsequent draws. This
     * callback occurs early in the document loading process, and as such you should
     * expect that linked resources (for example, CSS and images) may not be
     * available.
     *
     * <p>
     * For more fine-grained notification of visual state updates, see
     * {@link WebView#postVisualStateCallback}.
     *
     * <p>
     * Please note that all the conditions and recommendations applicable to
     * {@link WebView#postVisualStateCallback} also apply to this API.
     *
     * <p>
     * This callback is only called for main frame navigations.
     *
     * @param view The {@link android.webkit.WebView} for which the navigation
     *             occurred.
     * @param url  The URL corresponding to the page navigation that triggered this
     *             callback.
     */
    public void onPageCommitVisible(WebView view, String url) {
    }

    /**
     * Notify the host application of a resource request and allow the application
     * to return the data. If the return value is {@code null}, the WebView will
     * continue to load the resource as usual. Otherwise, the return response and
     * data will be used.
     *
     * <p>
     * This callback is invoked for a variety of URL schemes (e.g.,
     * {@code http(s):}, {@code
     * data:}, {@code file:}, etc.), not only those schemes which send requests over
     * the network. This is not called for {@code javascript:} URLs, {@code blob:}
     * URLs, or for assets accessed via {@code file:///android_asset/} or
     * {@code file:///android_res/} URLs.
     *
     * <p>
     * In the case of redirects, this is only called for the initial resource URL,
     * not any subsequent redirect URLs.
     *
     * <p class="note">
     * <b>Note:</b> This method is called on a thread other than the UI thread so
     * clients should exercise caution when accessing private data or the view
     * system.
     *
     * <p class="note">
     * <b>Note:</b> When Safe Browsing is enabled, these URLs still undergo Safe
     * Browsing checks. If this is undesired, whitelist the URL with
     * {@link WebView#setSafeBrowsingWhitelist} or ignore the warning with
     * {@link #onSafeBrowsingHit}.
     *
     * @param view The {@link android.webkit.WebView} that is requesting the
     *             resource.
     * @param url  The raw url of the resource.
     * @return A {@link android.webkit.WebResourceResponse} containing the response
     *         information or {@code null} if the WebView should load the resource
     *         itself.
     * @deprecated Use {@link #shouldInterceptRequest(WebView, WebResourceRequest)
     *             shouldInterceptRequest(WebView, WebResourceRequest)} instead.
     */
    @Deprecated
    public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
        return null;
    }

    /**
     * Notify the host application of a resource request and allow the application
     * to return the data. If the return value is {@code null}, the WebView will
     * continue to load the resource as usual. Otherwise, the return response and
     * data will be used.
     *
     * <p>
     * This callback is invoked for a variety of URL schemes (e.g.,
     * {@code http(s):}, {@code
     * data:}, {@code file:}, etc.), not only those schemes which send requests over
     * the network. This is not called for {@code javascript:} URLs, {@code blob:}
     * URLs, or for assets accessed via {@code file:///android_asset/} or
     * {@code file:///android_res/} URLs.
     *
     * <p>
     * In the case of redirects, this is only called for the initial resource URL,
     * not any subsequent redirect URLs.
     *
     * <p class="note">
     * <b>Note:</b> This method is called on a thread other than the UI thread so
     * clients should exercise caution when accessing private data or the view
     * system.
     *
     * <p class="note">
     * <b>Note:</b> When Safe Browsing is enabled, these URLs still undergo Safe
     * Browsing checks. If this is undesired, whitelist the URL with
     * {@link WebView#setSafeBrowsingWhitelist} or ignore the warning with
     * {@link #onSafeBrowsingHit}.
     *
     * @param view    The {@link android.webkit.WebView} that is requesting the
     *                resource.
     * @param request Object containing the details of the request.
     * @return A {@link android.webkit.WebResourceResponse} containing the response
     *         information or {@code null} if the WebView should load the resource
     *         itself.
     */
    public WebResourceResponse shouldInterceptRequest(WebView view, WebResourceRequest request) {
        return null;
    }

    /**
     * Report an error to the host application. These errors are unrecoverable (i.e.
     * the main resource is unavailable). The {@code errorCode} parameter
     * corresponds to one of the {@code ERROR_*} constants.
     * 
     * @param view        The WebView that is initiating the callback.
     * @param errorCode   The error code corresponding to an ERROR_* value.
     * @param description A String describing the error.
     * @param failingUrl  The url that failed to load.
     * @deprecated Use
     *             {@link #onReceivedError(WebView, WebResourceRequest, WebResourceError)
     *             onReceivedError(WebView, WebResourceRequest, WebResourceError)}
     *             instead.
     */
    @Deprecated
    public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
    }

}
