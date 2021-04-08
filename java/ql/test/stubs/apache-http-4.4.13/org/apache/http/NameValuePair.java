/*
 * $HeadURL: http://svn.apache.org/repos/asf/httpcomponents/httpcore/trunk/module-main/src/main/java/org/apache/http/NameValuePair.java $
 * $Revision: 496070 $
 * $Date: 2007-01-14 04:18:34 -0800 (Sun, 14 Jan 2007) $
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
 * A simple class encapsulating an attribute/value pair.
 * <p>
 * This class comforms to the generic grammar and formatting rules outlined in
 * the <a href=
 * "http://www.w3.org/Protocols/rfc2616/rfc2616-sec2.html#sec2.2">Section
 * 2.2</a> and <a href=
 * "http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.6">Section
 * 3.6</a> of <a href="http://www.w3.org/Protocols/rfc2616/rfc2616.txt">RFC
 * 2616</a>
 * </p>
 * <h>2.2 Basic Rules</h>
 * <p>
 * The following rules are used throughout this specification to describe basic
 * parsing constructs. The US-ASCII coded character set is defined by ANSI
 * X3.4-1986.
 * </p>
 * 
 * <pre>
 *     OCTET          = <any 8-bit sequence of data>
 *     CHAR           = <any US-ASCII character (octets 0 - 127)>
 *     UPALPHA        = <any US-ASCII uppercase letter "A".."Z">
 *     LOALPHA        = <any US-ASCII lowercase letter "a".."z">
 *     ALPHA          = UPALPHA | LOALPHA
 *     DIGIT          = <any US-ASCII digit "0".."9">
 *     CTL            = <any US-ASCII control character
 *                      (octets 0 - 31) and DEL (127)>
 *     CR             = <US-ASCII CR, carriage return (13)>
 *     LF             = <US-ASCII LF, linefeed (10)>
 *     SP             = <US-ASCII SP, space (32)>
 *     HT             = <US-ASCII HT, horizontal-tab (9)>
 *     <">            = <US-ASCII double-quote mark (34)>
 * </pre>
 * <p>
 * Many HTTP/1.1 header field values consist of words separated by LWS or
 * special characters. These special characters MUST be in a quoted string to be
 * used within a parameter value (as defined in section 3.6).
 * <p>
 * 
 * <pre>
 * token          = 1*<any CHAR except CTLs or separators>
 * separators     = "(" | ")" | "<" | ">" | "@"
 *                | "," | ";" | ":" | "\" | <">
 *                | "/" | "[" | "]" | "?" | "="
 *                | "{" | "}" | SP | HT
 * </pre>
 * <p>
 * A string of text is parsed as a single word if it is quoted using
 * double-quote marks.
 * </p>
 * 
 * <pre>
 * quoted-string  = ( <"> *(qdtext | quoted-pair ) <"> )
 * qdtext         = <any TEXT except <">>
 * </pre>
 * <p>
 * The backslash character ("\") MAY be used as a single-character quoting
 * mechanism only within quoted-string and comment constructs.
 * </p>
 * 
 * <pre>
 * quoted-pair    = "\" CHAR
 * </pre>
 * 
 * <h>3.6 Transfer Codings</h>
 * <p>
 * Parameters are in the form of attribute/value pairs.
 * </p>
 * 
 * <pre>
 * parameter               = attribute "=" value
 * attribute               = token
 * value                   = token | quoted-string
 * </pre>
 * 
 * @author <a href="mailto:oleg at ural.com">Oleg Kalnichevski</a>
 * 
 *
 * @deprecated Please use {@link java.net.URL#openConnection} instead. Please
 *             visit <a href=
 *             "http://android-developers.blogspot.com/2011/09/androids-http-clients.html">this
 *             webpage</a> for further details.
 */
@Deprecated
public interface NameValuePair {

    String getName();

    String getValue();

}
