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

package org.springframework.web.reactive.function.client;

import reactor.core.publisher.Mono;

/**
    Spring Reactor WebClient interface stub
 */
public interface WebClient {

	RequestHeadersUriSpec<?> get();
	RequestHeadersUriSpec<?> head();
	RequestBodyUriSpec post();
	RequestBodyUriSpec put();
	RequestBodyUriSpec patch();
	RequestHeadersUriSpec<?> delete();
	RequestHeadersUriSpec<?> options();

	static WebClient create(String baseUrl) {
		return null;
	}

	static WebClient create() {
		return null;
	}

	static WebClient.Builder builder() {
		return null;
	}

	interface Builder {
		Builder baseUrl(String baseUrl);
		Builder defaultHeader(String header, String... values);
		WebClient build();
	}

	interface UriSpec<S extends RequestHeadersSpec<?>> {
		S uri(String uri, Object... uriVariables);
	}

	interface RequestBodySpec extends RequestHeadersSpec<RequestBodySpec> {
	}

	interface RequestBodyUriSpec extends RequestBodySpec, RequestHeadersUriSpec<RequestBodySpec> {
	}

	interface ResponseSpec {
		<T> Mono<T> bodyToMono(Class<T> elementClass);
	}

	interface RequestHeadersUriSpec<S extends RequestHeadersSpec<S>>
			extends UriSpec<S>, RequestHeadersSpec<S> {
	}

	interface RequestHeadersSpec<S extends RequestHeadersSpec<S>> {
		ResponseSpec retrieve();
	}
}