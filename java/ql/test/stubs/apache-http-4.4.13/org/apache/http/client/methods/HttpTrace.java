/*
 * ====================================================================
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

package org.apache.http.client.methods;

import java.net.URI;

/**
 * HTTP TRACE method.
 * <p>
 * The HTTP TRACE method is defined in section 9.6 of
 * <a href="http://www.ietf.org/rfc/rfc2616.txt">RFC2616</a>:
 * </p>
 * <blockquote>
 *  The TRACE method is used to invoke a remote, application-layer loop-
 *  back of the request message. The final recipient of the request
 *  SHOULD reflect the message received back to the client as the
 *  entity-body of a 200 (OK) response. The final recipient is either the
 *  origin server or the first proxy or gateway to receive a Max-Forwards
 *  value of zero (0) in the request (see section 14.31). A TRACE request
 *  MUST NOT include an entity.
 * </blockquote>
 *
 * @since 4.0
 */
public class HttpTrace extends HttpRequestBase {

    public final static String METHOD_NAME = "TRACE";

    public HttpTrace() {
    }

    public HttpTrace(final URI uri) {
    }

    /**
     * @throws IllegalArgumentException if the uri is invalid.
     */
    public HttpTrace(final String uri) {
    }

    @Override
    public String getMethod() {
        return METHOD_NAME;
    }

}
