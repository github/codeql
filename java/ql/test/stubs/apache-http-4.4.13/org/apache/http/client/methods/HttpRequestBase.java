/*
 * $HeadURL: http://svn.apache.org/repos/asf/httpcomponents/httpclient/trunk/module-client/src/main/java/org/apache/http/client/methods/HttpRequestBase.java $
 * $Revision: 674186 $
 * $Date: 2008-07-05 05:18:54 -0700 (Sat, 05 Jul 2008) $
 *
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

import java.io.IOException;
import java.net.URI;

import org.apache.http.message.AbstractHttpMessage;
import org.apache.http.ProtocolVersion;
import org.apache.http.RequestLine;

/**
 * Basic implementation of an HTTP request that can be modified.
 *
 * @author <a href="mailto:oleg at ural.ru">Oleg Kalnichevski</a>
 *
 * @version $Revision: 674186 $
 * 
 * @since 4.0
 *
 * @deprecated Please use {@link java.net.URL#openConnection} instead. Please
 *             visit <a href=
 *             "http://android-developers.blogspot.com/2011/09/androids-http-clients.html">this
 *             webpage</a> for further details.
 */
@Deprecated
public abstract class HttpRequestBase extends AbstractHttpMessage {
    public HttpRequestBase() {
    }

    public abstract String getMethod();

    public ProtocolVersion getProtocolVersion() {
        return null;
    }

    public URI getURI() {
        return null;
    }

    public RequestLine getRequestLine() {
        return null;
    }

    public void setURI(final URI uri) {
    }

    public void abort() {
    }

    public boolean isAborted() {
        return false;
    }

    // Add method from `org.apache.http.HttpMessage`
    public void addHeader(String name, String value) {
    }

    // Add method from `org.apache.http.HttpMessage`
    public void setHeader(String name, String value) {
    }
}