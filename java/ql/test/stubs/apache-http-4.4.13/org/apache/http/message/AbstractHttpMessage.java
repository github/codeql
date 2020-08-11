/*
 * $HeadURL: http://svn.apache.org/repos/asf/httpcomponents/httpcore/trunk/module-main/src/main/java/org/apache/http/message/AbstractHttpMessage.java $
 * $Revision: 620287 $
 * $Date: 2008-02-10 07:15:53 -0800 (Sun, 10 Feb 2008) $
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

package org.apache.http.message;

import java.util.Iterator;

import org.apache.http.Header;
import org.apache.http.HeaderIterator;
import org.apache.http.HttpMessage;
import org.apache.http.params.HttpParams;

/**
 * Basic implementation of an HTTP message that can be modified.
 *
 * @author <a href="mailto:oleg at ural.ru">Oleg Kalnichevski</a>
 *
 * @version $Revision: 620287 $
 * 
 * @since 4.0
 *
 * @deprecated Please use {@link java.net.URL#openConnection} instead. Please
 *             visit <a href=
 *             "http://android-developers.blogspot.com/2011/09/androids-http-clients.html">this
 *             webpage</a> for further details.
 */
@Deprecated
public abstract class AbstractHttpMessage implements HttpMessage {
    // non-javadoc, see interface HttpMessage
    public boolean containsHeader(String name) {
        return false;
    }

    // non-javadoc, see interface HttpMessage
    public Header[] getHeaders(final String name) {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public Header getFirstHeader(final String name) {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public Header getLastHeader(final String name) {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public Header[] getAllHeaders() {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public void addHeader(final Header header) {
    }

    // non-javadoc, see interface HttpMessage
    public void addHeader(final String name, final String value) {
    }

    // non-javadoc, see interface HttpMessage
    public void setHeader(final Header header) {
    }

    // non-javadoc, see interface HttpMessage
    public void setHeader(final String name, final String value) {
    }

    // non-javadoc, see interface HttpMessage
    public void setHeaders(final Header[] headers) {
    }

    // non-javadoc, see interface HttpMessage
    public void removeHeader(final Header header) {
    }

    // non-javadoc, see interface HttpMessage
    public void removeHeaders(final String name) {
    }

    // non-javadoc, see interface HttpMessage
    public HeaderIterator headerIterator() {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public HeaderIterator headerIterator(String name) {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public HttpParams getParams() {
        return null;
    }

    // non-javadoc, see interface HttpMessage
    public void setParams(final HttpParams params) {
    }
}
