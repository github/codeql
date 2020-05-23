/*
 * Copyright 2002-2019 the original author or authors.
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

public interface RestOperations {
	<T> T getForObject(String url, Class<T> responseType, Object... uriVariables) throws RestClientException;
	<T> T getForObject(String url, Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
	<T> T getForObject(URI url, Class<T> responseType) throws RestClientException;
	<T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Object... uriVariables)
			throws RestClientException;
	<T> ResponseEntity<T> getForEntity(String url, Class<T> responseType, Map<String, ?> uriVariables)
			throws RestClientException;
	<T> ResponseEntity<T> getForEntity(URI url, Class<T> responseType) throws RestClientException;
	HttpHeaders headForHeaders(String url, Object... uriVariables) throws RestClientException;
	HttpHeaders headForHeaders(String url, Map<String, ?> uriVariables) throws RestClientException;
	HttpHeaders headForHeaders(URI url) throws RestClientException;
	URI postForLocation(String url,  Object request, Object... uriVariables) throws RestClientException;
	URI postForLocation(String url,  Object request, Map<String, ?> uriVariables)
			throws RestClientException;
	URI postForLocation(URI url,  Object request) throws RestClientException;
	<T> T postForObject(String url,  Object request, Class<T> responseType,
			Object... uriVariables) throws RestClientException;
	<T> T postForObject(String url,  Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException;
	<T> T postForObject(URI url,  Object request, Class<T> responseType) throws RestClientException;
	<T> ResponseEntity<T> postForEntity(String url,  Object request, Class<T> responseType,
			Object... uriVariables) throws RestClientException;
	<T> ResponseEntity<T> postForEntity(String url,  Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException;
	<T> ResponseEntity<T> postForEntity(URI url,  Object request, Class<T> responseType)
			throws RestClientException;
	void put(String url,  Object request, Object... uriVariables) throws RestClientException;
	void put(String url,  Object request, Map<String, ?> uriVariables) throws RestClientException;
	void put(URI url,  Object request) throws RestClientException;
	<T> T patchForObject(String url,  Object request, Class<T> responseType, Object... uriVariables)
			throws RestClientException;
	<T> T patchForObject(String url,  Object request, Class<T> responseType,
			Map<String, ?> uriVariables) throws RestClientException;
	<T> T patchForObject(URI url,  Object request, Class<T> responseType)
			throws RestClientException;
	void delete(String url, Object... uriVariables) throws RestClientException;
	void delete(String url, Map<String, ?> uriVariables) throws RestClientException;
	void delete(URI url) throws RestClientException;
	Set<HttpMethod> optionsForAllow(String url, Object... uriVariables) throws RestClientException;
	Set<HttpMethod> optionsForAllow(String url, Map<String, ?> uriVariables) throws RestClientException;
	Set<HttpMethod> optionsForAllow(URI url) throws RestClientException;
	<T> ResponseEntity<T> exchange(String url, HttpMethod method,  HttpEntity<?> requestEntity,
			Class<T> responseType, Object... uriVariables) throws RestClientException;
	<T> ResponseEntity<T> exchange(String url, HttpMethod method,  HttpEntity<?> requestEntity,
			Class<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
	<T> ResponseEntity<T> exchange(URI url, HttpMethod method,  HttpEntity<?> requestEntity,
			Class<T> responseType) throws RestClientException;
	<T> ResponseEntity<T> exchange(String url,HttpMethod method,  HttpEntity<?> requestEntity,
			ParameterizedTypeReference<T> responseType, Object... uriVariables) throws RestClientException;
	<T> ResponseEntity<T> exchange(String url, HttpMethod method,  HttpEntity<?> requestEntity,
			ParameterizedTypeReference<T> responseType, Map<String, ?> uriVariables) throws RestClientException;
	<T> ResponseEntity<T> exchange(URI url, HttpMethod method,  HttpEntity<?> requestEntity,
			ParameterizedTypeReference<T> responseType) throws RestClientException;
	<T> ResponseEntity<T> exchange(RequestEntity<?> requestEntity, Class<T> responseType)
			throws RestClientException;
	<T> ResponseEntity<T> exchange(RequestEntity<?> requestEntity, ParameterizedTypeReference<T> responseType)
			throws RestClientException;
	<T> T execute(String url, HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor, Object... uriVariables)
			throws RestClientException;
	<T> T execute(String url, HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor, Map<String, ?> uriVariables)
			throws RestClientException;
	<T> T execute(URI url, HttpMethod method,  RequestCallback requestCallback,
			 ResponseExtractor<T> responseExtractor) throws RestClientException;
}
