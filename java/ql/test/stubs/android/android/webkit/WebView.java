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

import android.content.Context;
import android.util.AttributeSet;

public class WebView {
  public WebView(Context context) {
  }

  public WebView(Context context, AttributeSet attrs) {
  }

  public WebView(Context context, AttributeSet attrs, int defStyle) {
  }

  public void setHorizontalScrollbarOverlay(boolean overlay) {
  }

  public void setVerticalScrollbarOverlay(boolean overlay) {
  }

  public boolean overlayHorizontalScrollbar() {
    return false;
  }

  public boolean overlayVerticalScrollbar() {
    return false;
  }

  public void savePassword(String host, String username, String password) {
  }

  public void setHttpAuthUsernamePassword(String host, String realm, String username, String password) {
  }

  public String[] getHttpAuthUsernamePassword(String host, String realm) {
    return null;
  }

  public void destroy() {
  }

  public static void enablePlatformNotifications() {
  }

  public static void disablePlatformNotifications() {
  }

  public void loadUrl(String url) {
  }

  public void loadData(String data, String mimeType, String encoding) {
  }

  public void loadDataWithBaseURL(String baseUrl, String data, String mimeType, String encoding, String failUrl) {
  }

  public void stopLoading() {
  }

  public void reload() {
  }

  public boolean canGoBack() {
    return false;
  }

  public void goBack() {
  }

  public boolean canGoForward() {
    return false;
  }

  public void goForward() {
  }

  public boolean canGoBackOrForward(int steps) {
    return false;
  }

  public void goBackOrForward(int steps) {
  }

  public boolean pageUp(boolean top) {
    return false;
  }

  public boolean pageDown(boolean bottom) {
    return false;
  }

  public void clearView() {
  }

  public float getScale() {
    return 0;
  }

  public void setInitialScale(int scaleInPercent) {
  }

  public void invokeZoomPicker() {
  }

  public String getUrl() {
    return null;
  }

  public String getTitle() {
    return null;
  }

  public int getProgress() {
    return 0;
  }

  public int getContentHeight() {
    return 0;
  }

  public void pauseTimers() {
  }

  public void resumeTimers() {
  }

  public void clearCache() {
  }

  public void clearFormData() {
  }

  public void clearHistory() {
  }

  public void clearSslPreferences() {
  }

  public static String findAddress(String addr) {
    return null;
  }

  public void addJavascriptInterface(Object obj, String interfaceName) {
  }

  public boolean zoomIn() {
    return false;
  }

  public boolean zoomOut() {
    return false;
  }

  public WebSettings getSettings() {
    return null;
  }

  public void setWebViewClient(WebViewClient webViewClient) {
  }

}
