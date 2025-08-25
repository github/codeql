/*
 * Copyright 2004, 2005, 2006 Acegi Technology Pty Limited
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

package org.springframework.security.web.savedrequest;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;

/**
 * A Bean implementation of SavedRequest
 *
 * @author Rob Winch
 * @since 5.1
 */
public class SimpleSavedRequest implements SavedRequest {

	public SimpleSavedRequest() {
	}

	public SimpleSavedRequest(String redirectUrl) {
	}

	public SimpleSavedRequest(SavedRequest request) {
	}

	@Override
	public String getRedirectUrl() {
		return null;
	}

	@Override
	public List<Cookie> getCookies() {
		return null;
	}

	@Override
	public String getMethod() {
		return null;
	}

	@Override
	public List<String> getHeaderValues(String name) {
		return null;
	}

	@Override
	public Collection<String> getHeaderNames() {
		return null;
	}

	@Override
	public List<Locale> getLocales() {
		return null;
	}

	@Override
	public String[] getParameterValues(String name) {
		return null;
	}

	@Override
	public Map<String, String[]> getParameterMap() {
		return null;
	}

	public void setRedirectUrl(String redirectUrl) {
	}

	public void setCookies(List<Cookie> cookies) {
	}

	public void setMethod(String method) {
	}

	public void setHeaders(Map<String, List<String>> headers) {
	}

	public void setLocales(List<Locale> locales) {
	}

	public void setParameters(Map<String, String[]> parameters) {
	}

}
