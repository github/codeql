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
  public boolean shouldOverrideUrlLoading(WebView view, String url) {
    return false;
  }

  public void onPageFinished(WebView view, String url) {
  }

  public void onLoadResource(WebView view, String url) {
  }

  public void onPageCommitVisible(WebView view, String url) {
  }

  public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
  }

  public void onScaleChanged(WebView view, float oldScale, float newScale) {
  }

}
