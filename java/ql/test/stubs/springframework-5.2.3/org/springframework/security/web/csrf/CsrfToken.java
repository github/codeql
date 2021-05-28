/*
 * Copyright 2002-2013 the original author or authors.
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

package org.springframework.security.web.csrf;

import java.io.Serializable;

/**
 * Provides the information about an expected CSRF token.
 *
 * @author Rob Winch
 * @since 3.2
 * @see DefaultCsrfToken
 */
public interface CsrfToken extends Serializable {

	/**
	 * Gets the HTTP header that the CSRF is populated on the response and can be placed
	 * on requests instead of the parameter. Cannot be null.
	 * @return the HTTP header that the CSRF is populated on the response and can be
	 * placed on requests instead of the parameter
	 */
	String getHeaderName();

	/**
	 * Gets the HTTP parameter name that should contain the token. Cannot be null.
	 * @return the HTTP parameter name that should contain the token.
	 */
	String getParameterName();

	/**
	 * Gets the token value. Cannot be null.
	 * @return the token value
	 */
	String getToken();

}
