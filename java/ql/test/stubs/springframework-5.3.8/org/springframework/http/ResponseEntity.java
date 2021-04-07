/*
 * Copyright 2002-2021 the original author or authors.
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
import java.net.URI;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.Optional;
import java.util.function.Consumer;
import org.springframework.lang.Nullable;
import org.springframework.util.MultiValueMap;

public class ResponseEntity<T> extends HttpEntity<T> {
	public ResponseEntity(HttpStatus status) {
 }

	public ResponseEntity(@Nullable T body, HttpStatus status) {
 }

	public ResponseEntity(MultiValueMap<String, String> headers, HttpStatus status) {
 }

	public ResponseEntity(@Nullable T body, @Nullable MultiValueMap<String, String> headers, HttpStatus status) {
 }

	public ResponseEntity(@Nullable T body, @Nullable MultiValueMap<String, String> headers, int rawStatus) {
 }

	public HttpStatus getStatusCode() {
   return null;
 }

	public int getStatusCodeValue() {
   return 0;
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

	public static BodyBuilder status(HttpStatus status) {
   return null;
 }

	public static BodyBuilder status(int status) {
   return null;
 }

	public static BodyBuilder ok() {
   return null;
 }

	public static <T> ResponseEntity<T> ok(@Nullable T body) {
   return null;
 }

	public static <T> ResponseEntity<T> of(Optional<T> body) {
   return null;
 }

	public static BodyBuilder created(URI location) {
   return null;
 }

	public static BodyBuilder accepted() {
   return null;
 }

	public static HeadersBuilder<?> noContent() {
   return null;
 }

	public static BodyBuilder badRequest() {
   return null;
 }

	public static HeadersBuilder<?> notFound() {
   return null;
 }

	public static BodyBuilder unprocessableEntity() {
   return null;
 }

	public interface HeadersBuilder<B extends HeadersBuilder<B>> {
		B header(String headerName, String... headerValues);

		B headers(@Nullable HttpHeaders headers);

		B headers(Consumer<HttpHeaders> headersConsumer);

		B allow(HttpMethod... allowedMethods);

		B eTag(String etag);

		B lastModified(ZonedDateTime lastModified);

		B lastModified(Instant lastModified);

		B lastModified(long lastModified);

		B location(URI location);

		B cacheControl(CacheControl cacheControl);

		B varyBy(String... requestHeaders);

		<T> ResponseEntity<T> build();

 }
	public interface BodyBuilder extends HeadersBuilder<BodyBuilder> {
		BodyBuilder contentLength(long contentLength);

		BodyBuilder contentType(MediaType contentType);

		<T> ResponseEntity<T> body(@Nullable T body);

 }
}
