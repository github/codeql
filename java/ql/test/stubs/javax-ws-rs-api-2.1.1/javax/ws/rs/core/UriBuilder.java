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
import java.lang.reflect.Method;
import java.net.URI;
import java.util.Map;

public abstract class UriBuilder {
    public static UriBuilder fromUri(URI uri) {
      return null;
    }

    public static UriBuilder fromUri(String uriTemplate) {
      return null;
    }

    public static UriBuilder fromLink(Link link) {
      return null;
    }

    public static UriBuilder fromPath(String path) throws IllegalArgumentException {
      return null;
    }

    public static UriBuilder fromResource(Class<?> resource) {
      return null;
    }

    public static UriBuilder fromMethod(Class<?> resource, String method) {
      return null;
    }

    @Override
    public abstract UriBuilder clone();

    public abstract UriBuilder uri(URI uri);

    public abstract UriBuilder uri(String uriTemplate);

    public abstract UriBuilder scheme(String scheme);

    public abstract UriBuilder schemeSpecificPart(String ssp);

    public abstract UriBuilder userInfo(String ui);

    public abstract UriBuilder host(String host);

    public abstract UriBuilder port(int port);

    public abstract UriBuilder replacePath(String path);

    public abstract UriBuilder path(String path);

    public abstract UriBuilder path(Class resource);

    public abstract UriBuilder path(Class resource, String method);

    public abstract UriBuilder path(Method method);

    public abstract UriBuilder segment(String... segments);

    public abstract UriBuilder replaceMatrix(String matrix);

    public abstract UriBuilder matrixParam(String name, Object... values);

    public abstract UriBuilder replaceMatrixParam(String name, Object... values);

    public abstract UriBuilder replaceQuery(String query);

    public abstract UriBuilder queryParam(String name, Object... values);

    public abstract UriBuilder replaceQueryParam(String name, Object... values);

    public abstract UriBuilder fragment(String fragment);

    public abstract UriBuilder resolveTemplate(String name, Object value);

    public abstract UriBuilder resolveTemplate(String name, Object value, boolean encodeSlashInPath);

    public abstract UriBuilder resolveTemplateFromEncoded(String name, Object value);

    public abstract UriBuilder resolveTemplates(Map<String, Object> templateValues);

    public abstract UriBuilder resolveTemplates(Map<String, Object> templateValues, boolean encodeSlashInPath)
            throws IllegalArgumentException;

    public abstract UriBuilder resolveTemplatesFromEncoded(Map<String, Object> templateValues);

    public abstract URI buildFromMap(Map<String, ?> values);

    public abstract URI buildFromMap(Map<String, ?> values, boolean encodeSlashInPath)
            throws IllegalArgumentException, UriBuilderException;

    public abstract URI buildFromEncodedMap(Map<String, ?> values)
            throws IllegalArgumentException, UriBuilderException;

    public abstract URI build(Object... values)
            throws IllegalArgumentException, UriBuilderException;

    public abstract URI build(Object[] values, boolean encodeSlashInPath)
            throws IllegalArgumentException, UriBuilderException;

    public abstract URI buildFromEncoded(Object... values)
            throws IllegalArgumentException, UriBuilderException;

    public abstract String toTemplate();

}
