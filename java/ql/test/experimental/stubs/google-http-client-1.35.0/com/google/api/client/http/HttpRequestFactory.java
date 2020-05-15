/*
 * Copyright (c) 2011 Google Inc.
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

import java.io.IOException;

public final class HttpRequestFactory {
  HttpRequestFactory(HttpTransport transport, HttpRequestInitializer initializer) { }
  public HttpTransport getTransport() { return null; }
  public HttpRequestInitializer getInitializer() { return null; }
  public HttpRequest buildRequest(String requestMethod, GenericUrl url, HttpContent content)
      throws IOException { return null; }
  public HttpRequest buildDeleteRequest(GenericUrl url) throws IOException { return null; }
  public HttpRequest buildGetRequest(GenericUrl url) throws IOException { return null; }
  public HttpRequest buildPostRequest(GenericUrl url, HttpContent content) throws IOException { return null; }
  public HttpRequest buildPutRequest(GenericUrl url, HttpContent content) throws IOException { return null; }
  public HttpRequest buildPatchRequest(GenericUrl url, HttpContent content) throws IOException { return null; }
  public HttpRequest buildHeadRequest(GenericUrl url) throws IOException { return null; }
}
