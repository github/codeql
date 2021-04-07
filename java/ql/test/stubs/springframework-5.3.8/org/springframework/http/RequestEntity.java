/*
 * Copyright 2002-2020 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.springframework.http;
import java.lang.reflect.Type;
import java.net.URI;
import java.nio.charset.Charset;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.Map;
import java.util.function.Consumer;
import org.springframework.lang.Nullable;
import org.springframework.util.MultiValueMap;

public class RequestEntity<T> extends HttpEntity<T> {
	public RequestEntity(HttpMethod method, URI url) {
 }

	public RequestEntity(@Nullable T body, HttpMethod method, URI url) {
 }

	public RequestEntity(@Nullable T body, HttpMethod method, URI url, Type type) {
 }

	public RequestEntity(MultiValueMap<String, String> headers, HttpMethod method, URI url) {
 }

	public RequestEntity(@Nullable T body, @Nullable MultiValueMap<String, String> headers,
			@Nullable HttpMethod method, URI url) {
 }

	public RequestEntity(@Nullable T body, @Nullable MultiValueMap<String, String> headers,
			@Nullable HttpMethod method, @Nullable URI url, @Nullable Type type) {
 }

	public HttpMethod getMethod() {
   return null;
 }

	public URI getUrl() {
   return null;
 }

	public Type getType() {
   return null;
 }

	@Override
	public boolean equals(@Nullable Object other) {
   return false;
 }

	@Override
	public int hashCode() {
   return 0;
 }

	@Override
	public String toString() {
   return null;
 }

	public static BodyBuilder method(HttpMethod method, URI url) {
   return null;
 }

	public static BodyBuilder method(HttpMethod method, String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static BodyBuilder method(HttpMethod method, String uriTemplate, Map<String, ?> uriVariables) {
   return null;
 }

	public static HeadersBuilder<?> get(URI url) {
   return null;
 }

	public static HeadersBuilder<?> get(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static HeadersBuilder<?> head(URI url) {
   return null;
 }

	public static HeadersBuilder<?> head(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static BodyBuilder post(URI url) {
   return null;
 }

	public static BodyBuilder post(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static BodyBuilder put(URI url) {
   return null;
 }

	public static BodyBuilder put(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static BodyBuilder patch(URI url) {
   return null;
 }

	public static BodyBuilder patch(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static HeadersBuilder<?> delete(URI url) {
   return null;
 }

	public static HeadersBuilder<?> delete(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public static HeadersBuilder<?> options(URI url) {
   return null;
 }

	public static HeadersBuilder<?> options(String uriTemplate, Object... uriVariables) {
   return null;
 }

	public interface HeadersBuilder<B extends HeadersBuilder<B>> {
		B header(String headerName, String... headerValues);

		B headers(@Nullable HttpHeaders headers);

		B headers(Consumer<HttpHeaders> headersConsumer);

		B accept(MediaType... acceptableMediaTypes);

		B acceptCharset(Charset... acceptableCharsets);

		B ifModifiedSince(ZonedDateTime ifModifiedSince);

		B ifModifiedSince(Instant ifModifiedSince);

		B ifModifiedSince(long ifModifiedSince);

		B ifNoneMatch(String... ifNoneMatches);

		RequestEntity<Void> build();

 }
	public interface BodyBuilder extends HeadersBuilder<BodyBuilder> {
		BodyBuilder contentLength(long contentLength);

		BodyBuilder contentType(MediaType contentType);

		<T> RequestEntity<T> body(T body);

		<T> RequestEntity<T> body(T body, Type type);

 }
// 	public static class UriTemplateRequestEntity<T> extends RequestEntity<T> {
// 		public String getUriTemplate() {
//     return null;
//   }

// 		public Object[] getVars() {
//     return null;
//   }

// 		public Map<String, ?> getVarsMap() {
//     return null;
//   }

// 		@Override
// 		public String toString() {
//     return null;
//   }

//  }
}
