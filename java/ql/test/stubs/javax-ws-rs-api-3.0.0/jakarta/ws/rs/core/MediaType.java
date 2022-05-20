/*
 * Copyright (c) 2010, 2019 Oracle and/or its affiliates. All rights reserved.
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

package jakarta.ws.rs.core;
import java.util.Map;

public class MediaType {
    public final static MediaType WILDCARD_TYPE = new MediaType();

    public final static MediaType APPLICATION_XML_TYPE = new MediaType("application", "xml");

    public final static MediaType APPLICATION_ATOM_XML_TYPE = new MediaType("application", "atom+xml");

    public final static MediaType APPLICATION_XHTML_XML_TYPE = new MediaType("application", "xhtml+xml");

    public final static MediaType APPLICATION_SVG_XML_TYPE = new MediaType("application", "svg+xml");

    public final static MediaType APPLICATION_JSON_TYPE = new MediaType("application", "json");

    public final static MediaType APPLICATION_FORM_URLENCODED_TYPE = new MediaType("application", "x-www-form-urlencoded");

    public final static MediaType MULTIPART_FORM_DATA_TYPE = new MediaType("multipart", "form-data");

    public final static MediaType APPLICATION_OCTET_STREAM_TYPE = new MediaType("application", "octet-stream");

    public final static String TEXT_PLAIN = "text/plain";

    public final static MediaType TEXT_PLAIN_TYPE = new MediaType("text", "plain");

    public final static String TEXT_XML = "text/xml";

    public final static MediaType TEXT_XML_TYPE = new MediaType("text", "xml");

    public final static String TEXT_HTML = "text/html";

    public final static MediaType TEXT_HTML_TYPE = new MediaType("text", "html");

    public static final MediaType SERVER_SENT_EVENTS_TYPE = new MediaType("text", "event-stream");

    public static final MediaType APPLICATION_JSON_PATCH_JSON_TYPE = new MediaType("application", "json-patch+json");

    public static MediaType valueOf(final String type) {
      return null;
    }

    public MediaType(final String type, final String subtype, final Map<String, String> parameters) {
    }

    public MediaType(final String type, final String subtype) {
    }

    public MediaType(final String type, final String subtype, final String charset) {
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

    public MediaType withCharset(final String charset) {
      return null;
    }

    public boolean isCompatible(final MediaType other) {
      return false;
    }

    @Override
    public boolean equals(final Object obj) {
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
