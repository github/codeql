/*
 * Copyright (C) 2007 The Android Open Source Project
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

// create a class derived from this, and return an instance of it in the
// WebViewProvider.getWebSettingsProvider() method implementation.
public abstract class WebSettings {

  public @interface CacheMode {
  }

  public void setJavaScriptEnabled(boolean b) {
  }

  public void setAllowUniversalAccessFromFileURLs(boolean b) {
  }

  public void setAllowFileAccessFromFileURLs(boolean b) {
  }
}