/*
 * Copyright (c) 2010 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.api.client.http;

import java.net.URI;
import java.net.URL;

public class GenericUrl {
    public GenericUrl() { }
    public GenericUrl(String encodedUrl) { }
    public GenericUrl(String encodedUrl, boolean verbatim) { }
    public GenericUrl(URI uri) { }
    public GenericUrl(URI uri, boolean verbatim) { }
    public GenericUrl(URL url) { }
    public GenericUrl(URL url, boolean verbatim) { }
    public String getHost() { return null; }
    public final void setHost(String host) { }
    public final URI toURI() { return null; }
    public final URL toURL() { return null; }
    public final URL toURL(String relativeUrl) { return null; }
}
