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
import java.lang.annotation.Annotation;
import java.net.URI;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

public abstract class Response implements AutoCloseable {
    public abstract int getStatus();

    public abstract StatusType getStatusInfo();

    public abstract Object getEntity();

    public abstract <T> T readEntity(Class<T> entityType);

    // public abstract <T> T readEntity(GenericType<T> entityType);

    public abstract <T> T readEntity(Class<T> entityType, Annotation[] annotations);

    // public abstract <T> T readEntity(GenericType<T> entityType, Annotation[] annotations);

    public abstract boolean hasEntity();

    public abstract boolean bufferEntity();

    @Override
    public abstract void close();

    public abstract MediaType getMediaType();

    public abstract Locale getLanguage();

    public abstract int getLength();

    public abstract Set<String> getAllowedMethods();

    public abstract Map<String, NewCookie> getCookies();

    public abstract EntityTag getEntityTag();

    public abstract Date getDate();

    public abstract Date getLastModified();

    public abstract URI getLocation();

    public abstract Set<Link> getLinks();

    public abstract boolean hasLink(String relation);

    public abstract Link getLink(String relation);

    public abstract Link.Builder getLinkBuilder(String relation);

    public abstract MultivaluedMap<String, Object> getMetadata();

    public MultivaluedMap<String, Object> getHeaders() {
      return null;
    }

    public abstract MultivaluedMap<String, String> getStringHeaders();

    public abstract String getHeaderString(String name);

    public static ResponseBuilder fromResponse(final Response response) {
      return null;
    }

    public static ResponseBuilder status(final StatusType status) {
      return null;
    }

    public static ResponseBuilder status(final Status status) {
      return null;
    }

    public static ResponseBuilder status(final int status) {
      return null;
    }

    public static ResponseBuilder status(final int status, final String reasonPhrase) {
      return null;
    }

    public static ResponseBuilder ok() {
      return null;
    }

    public static ResponseBuilder ok(final Object entity) {
      return null;
    }

    public static ResponseBuilder ok(final Object entity, final MediaType type) {
      return null;
    }

    public static ResponseBuilder ok(final Object entity, final String type) {
      return null;
    }

    public static ResponseBuilder ok(final Object entity, final Variant variant) {
      return null;
    }

    public static ResponseBuilder serverError() {
      return null;
    }

    public static ResponseBuilder created(final URI location) {
      return null;
    }

    public static ResponseBuilder accepted() {
      return null;
    }

    public static ResponseBuilder accepted(final Object entity) {
      return null;
    }

    public static ResponseBuilder noContent() {
      return null;
    }

    public static ResponseBuilder notModified() {
      return null;
    }

    public static ResponseBuilder notModified(final EntityTag tag) {
      return null;
    }

    public static ResponseBuilder notModified(final String tag) {
      return null;
    }

    public static ResponseBuilder seeOther(final URI location) {
      return null;
    }

    public static ResponseBuilder temporaryRedirect(final URI location) {
      return null;
    }

    public static ResponseBuilder notAcceptable(final List<Variant> variants) {
      return null;
    }

    public static abstract class ResponseBuilder {
        public abstract Response build();

        @Override
        public abstract ResponseBuilder clone();

        public abstract ResponseBuilder status(int status);

        public abstract ResponseBuilder status(int status, String reasonPhrase);

        public ResponseBuilder status(final StatusType status) {
          return null;
        }

        public ResponseBuilder status(final Status status) {
          return null;
        }

        public abstract ResponseBuilder entity(Object entity);

        public abstract ResponseBuilder entity(Object entity, Annotation[] annotations);

        public abstract ResponseBuilder allow(String... methods);

        public abstract ResponseBuilder allow(Set<String> methods);

        public abstract ResponseBuilder cacheControl(CacheControl cacheControl);

        public abstract ResponseBuilder encoding(String encoding);

        public abstract ResponseBuilder header(String name, Object value);

        public abstract ResponseBuilder replaceAll(MultivaluedMap<String, Object> headers);

        public abstract ResponseBuilder language(String language);

        public abstract ResponseBuilder language(Locale language);

        public abstract ResponseBuilder type(MediaType type);

        public abstract ResponseBuilder type(String type);

        public abstract ResponseBuilder variant(Variant variant);

        public abstract ResponseBuilder contentLocation(URI location);

        public abstract ResponseBuilder cookie(NewCookie... cookies);

        public abstract ResponseBuilder expires(Date expires);

        public abstract ResponseBuilder lastModified(Date lastModified);

        public abstract ResponseBuilder location(URI location);

        public abstract ResponseBuilder tag(EntityTag tag);

        public abstract ResponseBuilder tag(String tag);

        public abstract ResponseBuilder variants(Variant... variants);

        public abstract ResponseBuilder variants(List<Variant> variants);

        public abstract ResponseBuilder links(Link... links);

        public abstract ResponseBuilder link(URI uri, String rel);

        public abstract ResponseBuilder link(String uri, String rel);

    }
    public interface StatusType {
        public int getStatusCode();

        public Status.Family getFamily();

        public String getReasonPhrase();

        public default Status toEnum() {
          return null;
        }

    }
    public enum Status implements StatusType {
        DUMMY_STATUS;

        public enum Family {
            DUMMY_FAMILY;

            public static Family familyOf(final int statusCode) {
              return null;
            }

        }
        @Override
        public Family getFamily() {
          return null;
        }

        @Override
        public int getStatusCode() {
          return 0;
        }

        @Override
        public String getReasonPhrase() {
          return null;
        }

        @Override
        public String toString() {
          return null;
        }

        public static Status fromStatusCode(final int statusCode) {
          return null;
        }

    }
}
