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
import java.io.Serializable;
import java.net.InetSocketAddress;
import java.net.URI;
import java.nio.charset.Charset;
import java.time.Duration;
import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import org.springframework.lang.Nullable;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

public class HttpHeaders implements MultiValueMap<String, String>, Serializable {
	public static final HttpHeaders EMPTY = null;

	public HttpHeaders() {
 }

	public HttpHeaders(MultiValueMap<String, String> headers) {
 }

	public List<String> getOrEmpty(Object headerName) {
   return null;
 }

	public void setAccept(List<MediaType> acceptableMediaTypes) {
 }

	public List<MediaType> getAccept() {
   return null;
 }

	public void setAcceptLanguage(List<Locale.LanguageRange> languages) {
 }

	public List<Locale.LanguageRange> getAcceptLanguage() {
   return null;
 }

	public void setAcceptLanguageAsLocales(List<Locale> locales) {
 }

	public List<Locale> getAcceptLanguageAsLocales() {
   return null;
 }

	public void setAccessControlAllowCredentials(boolean allowCredentials) {
 }

	public boolean getAccessControlAllowCredentials() {
   return false;
 }

	public void setAccessControlAllowHeaders(List<String> allowedHeaders) {
 }

	public List<String> getAccessControlAllowHeaders() {
   return null;
 }

	public void setAccessControlAllowMethods(List<HttpMethod> allowedMethods) {
 }

	public List<HttpMethod> getAccessControlAllowMethods() {
   return null;
 }

	public void setAccessControlAllowOrigin(@Nullable String allowedOrigin) {
 }

	public String getAccessControlAllowOrigin() {
   return null;
 }

	public void setAccessControlExposeHeaders(List<String> exposedHeaders) {
 }

	public List<String> getAccessControlExposeHeaders() {
   return null;
 }

	public void setAccessControlMaxAge(Duration maxAge) {
 }

	public void setAccessControlMaxAge(long maxAge) {
 }

	public long getAccessControlMaxAge() {
   return 0;
 }

	public void setAccessControlRequestHeaders(List<String> requestHeaders) {
 }

	public List<String> getAccessControlRequestHeaders() {
   return null;
 }

	public void setAccessControlRequestMethod(@Nullable HttpMethod requestMethod) {
 }

	public HttpMethod getAccessControlRequestMethod() {
   return null;
 }

	public void setAcceptCharset(List<Charset> acceptableCharsets) {
 }

	public List<Charset> getAcceptCharset() {
   return null;
 }

	public void setAllow(Set<HttpMethod> allowedMethods) {
 }

	public Set<HttpMethod> getAllow() {
   return null;
 }

	public void setBasicAuth(String username, String password) {
 }

	public void setBasicAuth(String username, String password, @Nullable Charset charset) {
 }

	public void setBasicAuth(String encodedCredentials) {
 }

	public void setBearerAuth(String token) {
 }

	public void setCacheControl(CacheControl cacheControl) {
 }

	public void setCacheControl(@Nullable String cacheControl) {
 }

	public String getCacheControl() {
   return null;
 }

	public void setConnection(String connection) {
 }

	public void setConnection(List<String> connection) {
 }

	public List<String> getConnection() {
   return null;
 }

	public void setContentDispositionFormData(String name, @Nullable String filename) {
 }

	public void setContentDisposition(ContentDisposition contentDisposition) {
 }

	public ContentDisposition getContentDisposition() {
   return null;
 }

	public void setContentLanguage(@Nullable Locale locale) {
 }

	public Locale getContentLanguage() {
   return null;
 }

	public void setContentLength(long contentLength) {
 }

	public long getContentLength() {
   return 0;
 }

	public void setContentType(@Nullable MediaType mediaType) {
 }

	public MediaType getContentType() {
   return null;
 }

	public void setDate(ZonedDateTime date) {
 }

	public void setDate(Instant date) {
 }

	public void setDate(long date) {
 }

	public long getDate() {
   return 0;
 }

	public void setETag(@Nullable String etag) {
 }

	public String getETag() {
   return null;
 }

	public void setExpires(ZonedDateTime expires) {
 }

	public void setExpires(Instant expires) {
 }

	public void setExpires(long expires) {
 }

	public long getExpires() {
   return 0;
 }

	public void setHost(@Nullable InetSocketAddress host) {
 }

	public InetSocketAddress getHost() {
   return null;
 }

	public void setIfMatch(String ifMatch) {
 }

	public void setIfMatch(List<String> ifMatchList) {
 }

	public List<String> getIfMatch() {
   return null;
 }

	public void setIfModifiedSince(ZonedDateTime ifModifiedSince) {
 }

	public void setIfModifiedSince(Instant ifModifiedSince) {
 }

	public void setIfModifiedSince(long ifModifiedSince) {
 }

	public long getIfModifiedSince() {
   return 0;
 }

	public void setIfNoneMatch(String ifNoneMatch) {
 }

	public void setIfNoneMatch(List<String> ifNoneMatchList) {
 }

	public List<String> getIfNoneMatch() {
   return null;
 }

	public void setIfUnmodifiedSince(ZonedDateTime ifUnmodifiedSince) {
 }

	public void setIfUnmodifiedSince(Instant ifUnmodifiedSince) {
 }

	public void setIfUnmodifiedSince(long ifUnmodifiedSince) {
 }

	public long getIfUnmodifiedSince() {
   return 0;
 }

	public void setLastModified(ZonedDateTime lastModified) {
 }

	public void setLastModified(Instant lastModified) {
 }

	public void setLastModified(long lastModified) {
 }

	public long getLastModified() {
   return 0;
 }

	public void setLocation(@Nullable URI location) {
 }

	public URI getLocation() {
   return null;
 }

	public void setOrigin(@Nullable String origin) {
 }

	public String getOrigin() {
   return null;
 }

	public void setPragma(@Nullable String pragma) {
 }

	public String getPragma() {
   return null;
 }

	public void setRange(List<HttpRange> ranges) {
 }

	public List<HttpRange> getRange() {
   return null;
 }

	public void setUpgrade(@Nullable String upgrade) {
 }

	public String getUpgrade() {
   return null;
 }

	public void setVary(List<String> requestHeaders) {
 }

	public List<String> getVary() {
   return null;
 }

	public void setZonedDateTime(String headerName, ZonedDateTime date) {
 }

	public void setInstant(String headerName, Instant date) {
 }

	public void setDate(String headerName, long date) {
 }

	public long getFirstDate(String headerName) {
   return 0;
 }

	public ZonedDateTime getFirstZonedDateTime(String headerName) {
   return null;
 }

	public List<String> getValuesAsList(String headerName) {
   return null;
 }

	public void clearContentHeaders() {
 }

	@Override
	public String getFirst(String headerName) {
   return null;
 }

	@Override
	public void add(String headerName, @Nullable String headerValue) {
 }

	@Override
	public void addAll(String key, List<? extends String> values) {
 }

	@Override
	public void addAll(MultiValueMap<String, String> values) {
 }

	@Override
	public void set(String headerName, @Nullable String headerValue) {
 }

	@Override
	public void setAll(Map<String, String> values) {
 }

	@Override
	public Map<String, String> toSingleValueMap() {
   return null;
 }

	@Override
	public int size() {
   return 0;
 }

	@Override
	public boolean isEmpty() {
   return false;
 }

	@Override
	public boolean containsKey(Object key) {
   return false;
 }

	@Override
	public boolean containsValue(Object value) {
   return false;
 }

	@Override
	public List<String> get(Object key) {
   return null;
 }

	@Override
	public List<String> put(String key, List<String> value) {
   return null;
 }

	@Override
	public List<String> remove(Object key) {
   return null;
 }

	@Override
	public void putAll(Map<? extends String, ? extends List<String>> map) {
 }

	@Override
	public void clear() {
 }

	@Override
	public Set<String> keySet() {
   return null;
 }

	@Override
	public Collection<List<String>> values() {
   return null;
 }

	@Override
	public Set<Entry<String, List<String>>> entrySet() {
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

	public static HttpHeaders readOnlyHttpHeaders(MultiValueMap<String, String> headers) {
   return null;
 }

	public static HttpHeaders readOnlyHttpHeaders(HttpHeaders headers) {
   return null;
 }

	public static HttpHeaders writableHttpHeaders(HttpHeaders headers) {
   return null;
 }

	public static String formatHeaders(MultiValueMap<String, String> headers) {
   return null;
 }

	public static String encodeBasicAuth(String username, String password, @Nullable Charset charset) {
   return null;
 }

}
