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

package org.springframework.web.client;

import java.net.URI;
import java.util.Map;
import java.util.Set;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.http.client.support.InterceptingHttpAccessor;

public class RestTemplate extends InterceptingHttpAccessor implements RestOperations {
	public RestTemplate() { }

	@Override
	public <T> T getForObject(String url, Class<T> responseType, Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> T getForObject(String url, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> T getForObject(URI url, Class<T> responseType) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Object... uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Map<String, ?> uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> getForEntity(URI url, Class<T> responseType) throws RestClientException {
		return null;
	}


	// HEAD

	@Override
	public HttpHeaders headForHeaders(String url, Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public HttpHeaders headForHeaders(String url, Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public HttpHeaders headForHeaders(URI url) throws RestClientException {
		return null;
	}


	// POST

	@Override
	public URI postForLocation(String url,  Object request, Object... uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public URI postForLocation(String url,  Object request, Map<String, ?> uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public URI postForLocation(URI url,  Object request) throws RestClientException {
		return null;
	}

	@Override
	public <T> T postForObject(String url,  Object request, Class<T> responseType,
			Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> T postForObject(String url,  Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	
	public <T> T postForObject(URI url,  Object request, Class<T> responseType)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> postForEntity(String url,  Object request,
			Class<T> responseType, Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> postForEntity(String url,  Object request,
			Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> postForEntity(URI url,  Object request, Class<T> responseType)
			throws RestClientException {
		return null;
	}


	// PUT

	@Override
	public void put(String url,  Object request, Object... uriVariables)
			throws RestClientException { }

	@Override
	public void put(String url,  Object request, Map<String, ?> uriVariables)
			throws RestClientException { }

	@Override
	public void put(URI url,  Object request) throws RestClientException { }


	// PATCH

	@Override
	
	public <T> T patchForObject(String url,  Object request, Class<T> responseType,
			Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> T patchForObject(String url,  Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> T patchForObject(URI url,  Object request, Class<T> responseType)
			throws RestClientException {
		return null;
	}


	// DELETE

	@Override
	public void delete(String url, Object... uriVariables) throws RestClientException { }

	@Override
	public void delete(String url, Map<String, ?> uriVariables) throws RestClientException { }

	@Override
	public void delete(URI url) throws RestClientException { }


	// OPTIONS

	@Override
	public Set<HttpMethod> optionsForAllow(String url, Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public Set<HttpMethod> optionsForAllow(String url, Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public Set<HttpMethod> optionsForAllow(URI url) throws RestClientException {
		return null;
	}


	// exchange

	@Override
	public <T> ResponseEntity<T> exchange(String url, HttpMethod method,
			 HttpEntity<?> requestEntity, Class<T> responseType, Object... uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(String url, HttpMethod method,
			 HttpEntity<?> requestEntity, Class<T> responseType, Map<String, ?> uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(URI url, HttpMethod method,  HttpEntity<?> requestEntity,
			Class<T> responseType) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(String url, HttpMethod method,  HttpEntity<?> requestEntity,
			ParameterizedTypeReference<T> responseType, Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(String url, HttpMethod method,  HttpEntity<?> requestEntity,
			ParameterizedTypeReference<T> responseType, Map<String, ?> uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(URI url, HttpMethod method,  HttpEntity<?> requestEntity,
			ParameterizedTypeReference<T> responseType) throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(RequestEntity<?> requestEntity, Class<T> responseType)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> ResponseEntity<T> exchange(RequestEntity<?> requestEntity, ParameterizedTypeReference<T> responseType)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> T execute(String url, HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor, Object... uriVariables) throws RestClientException {
		return null;
	}

	@Override
	public <T> T execute(String url, HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor, Map<String, ?> uriVariables)
			throws RestClientException {
		return null;
	}

	@Override
	public <T> T execute(URI url, HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor) throws RestClientException {
		return null;
	}

	
	protected <T> T doExecute(URI url,  HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor) throws RestClientException {
		return null;
	}
}
