/*
 * Copyright 2002-2016 the original author or authors.
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

import java.util.Collection;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.Cookie;

/**
 * Encapsulates the functionality required of a cached request for both an authentication
 * mechanism (typically form-based login) to redirect to the original URL and for a
 * <tt>RequestCache</tt> to build a wrapped request, reproducing the original request
 * data.
 *
 * @author Luke Taylor
 * @since 3.0
 */
public interface SavedRequest extends java.io.Serializable {

	/**
	 * @return the URL for the saved request, allowing a redirect to be performed.
	 */
	String getRedirectUrl();

	List<Cookie> getCookies();

	String getMethod();

	List<String> getHeaderValues(String name);

	Collection<String> getHeaderNames();

	List<Locale> getLocales();

	String[] getParameterValues(String name);

	Map<String, String[]> getParameterMap();

}
