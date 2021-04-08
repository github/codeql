/*
 * $HeadURL: http://svn.apache.org/repos/asf/httpcomponents/httpcore/trunk/module-main/src/main/java/org/apache/http/Header.java $
 * $Revision: 569636 $
 * $Date: 2007-08-25 00:34:47 -0700 (Sat, 25 Aug 2007) $
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

package org.apache.http;

/**
 * Represents an HTTP header field.
 * 
 * <p>
 * The HTTP header fields follow the same generic format as that given in
 * Section 3.1 of RFC 822. Each header field consists of a name followed by a
 * colon (":") and the field value. Field names are case-insensitive. The field
 * value MAY be preceded by any amount of LWS, though a single SP is preferred.
 *
 * <pre>
 *     message-header = field-name ":" [ field-value ]
 *     field-name     = token
 *     field-value    = *( field-content | LWS )
 *     field-content  = &lt;the OCTETs making up the field-value
 *                      and consisting of either *TEXT or combinations
 *                      of token, separators, and quoted-string&gt;
 * </pre>
 * 
 * @author <a href="mailto:remm@apache.org">Remy Maucherat</a>
 * @author <a href="mailto:oleg at ural.ru">Oleg Kalnichevski</a>
 * @version $Revision: 569636 $
 *
 * @deprecated Please use {@link java.net.URL#openConnection} instead. Please
 *             visit <a href=
 *             "http://android-developers.blogspot.com/2011/09/androids-http-clients.html">this
 *             webpage</a> for further details.
 */
@Deprecated
public interface Header {

    String getName();

    String getValue();

    HeaderElement[] getElements() throws ParseException;

}
