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
import org.springframework.lang.Nullable;
import org.springframework.util.MultiValueMap;

public class HttpEntity<T> {
	public static final HttpEntity<?> EMPTY = null;

	protected HttpEntity() {
 }

	public HttpEntity(T body) {
 }

	public HttpEntity(MultiValueMap<String, String> headers) {
 }

	public HttpEntity(@Nullable T body, @Nullable MultiValueMap<String, String> headers) {
 }

	public HttpHeaders getHeaders() {
   return null;
 }

	public T getBody() {
   return null;
 }

	public boolean hasBody() {
   return false;
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

}
