/*
 * Copyright (c) 2010, 2017 Oracle and/or its affiliates. All rights reserved.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License v. 2.0, which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary
 * Licenses when the conditions for such availability set forth in the
 * Eclipse Public License v. 2.0 are satisfied: GNU General Public License,
 * version 2 with the GNU Classpath Exception, which is available at
 * https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 */

package javax.ws.rs.core;
import java.util.Map;

public class MediaType {
    /**
     * The media type {@code charset} parameter name.
     */
    public static final String CHARSET_PARAMETER = "";
    /**
     * The value of a type or subtype wildcard {@value #MEDIA_TYPE_WILDCARD}.
     */
    public static final String MEDIA_TYPE_WILDCARD = "";
    // Common media type constants
    /**
     * A {@code String} constant representing wildcard {@value #WILDCARD} media type .
     */
    public static final String WILDCARD = "";
    /**
     * A {@link MediaType} constant representing wildcard {@value #WILDCARD} media type.
     */
    public static final MediaType WILDCARD_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_XML} media type.
     */
    public static final String APPLICATION_XML = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_XML} media type.
     */
    public static final MediaType APPLICATION_XML_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_ATOM_XML} media type.
     */
    public static final String APPLICATION_ATOM_XML = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_ATOM_XML} media type.
     */
    public static final MediaType APPLICATION_ATOM_XML_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_XHTML_XML} media type.
     */
    public static final String APPLICATION_XHTML_XML = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_XHTML_XML} media type.
     */
    public static final MediaType APPLICATION_XHTML_XML_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_SVG_XML} media type.
     */
    public static final String APPLICATION_SVG_XML = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_SVG_XML} media type.
     */
    public static final MediaType APPLICATION_SVG_XML_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_JSON} media type.
     */
    public static final String APPLICATION_JSON = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_JSON} media type.
     */
    public static final MediaType APPLICATION_JSON_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_FORM_URLENCODED} media type.
     */
    public static final String APPLICATION_FORM_URLENCODED = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_FORM_URLENCODED} media type.
     */
    public static final MediaType APPLICATION_FORM_URLENCODED_TYPE = null;
    /**
     * A {@code String} constant representing {@value #MULTIPART_FORM_DATA} media type.
     */
    public static final String MULTIPART_FORM_DATA = "";
    /**
     * A {@link MediaType} constant representing {@value #MULTIPART_FORM_DATA} media type.
     */
    public static final MediaType MULTIPART_FORM_DATA_TYPE = null;
    /**
     * A {@code String} constant representing {@value #APPLICATION_OCTET_STREAM} media type.
     */
    public static final String APPLICATION_OCTET_STREAM = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_OCTET_STREAM} media type.
     */
    public static final MediaType APPLICATION_OCTET_STREAM_TYPE = null;
    /**
     * A {@code String} constant representing {@value #TEXT_PLAIN} media type.
     */
    public static final String TEXT_PLAIN = "";
    /**
     * A {@link MediaType} constant representing {@value #TEXT_PLAIN} media type.
     */
    public static final MediaType TEXT_PLAIN_TYPE = null;
    /**
     * A {@code String} constant representing {@value #TEXT_XML} media type.
     */
    public static final String TEXT_XML = "";
    /**
     * A {@link MediaType} constant representing {@value #TEXT_XML} media type.
     */
    public static final MediaType TEXT_XML_TYPE = null;
    /**
     * A {@code String} constant representing {@value #TEXT_HTML} media type.
     */
    public static final String TEXT_HTML = "";
    /**
     * A {@link MediaType} constant representing {@value #TEXT_HTML} media type.
     */
    public static final MediaType TEXT_HTML_TYPE = null;
    /**
     * {@link String} representation of Server sent events media type. ("{@value}").
     */
    public static final String SERVER_SENT_EVENTS = "";
    /**
     * Server sent events media type.
     */
    public static final MediaType SERVER_SENT_EVENTS_TYPE = null;
    /**
     * {@link String} representation of {@value #APPLICATION_JSON_PATCH_JSON} media type..
     */
    public static final String APPLICATION_JSON_PATCH_JSON = "";
    /**
     * A {@link MediaType} constant representing {@value #APPLICATION_JSON_PATCH_JSON} media type.
     */
    public static final MediaType APPLICATION_JSON_PATCH_JSON_TYPE = null;

    public static MediaType valueOf(String type){
      return null;
    }

    public MediaType(String type, String subtype, Map<String, String> parameters) {
    }

    public MediaType(String type, String subtype) {
    }

    public MediaType(String type, String subtype, String charset) {
    }

    public MediaType() {
    }

    public String getType() {
      return null;
    }

    public boolean isWildcardType() {
      return false;
    }

    public String getSubtype() {
      return null;
    }

    public boolean isWildcardSubtype() {
      return false;
    }

    public Map<String, String> getParameters() {
      return null;
    }

    public MediaType withCharset(String charset) {
      return null;
    }

    public boolean isCompatible(MediaType other) {
      return false;
    }

    @Override
    public boolean equals(Object obj) {
      return false;
    }

    @Override
    public int hashCode() {
      return 0;
    }

    @Override
    public String toString() {
      return null;
    }

}
