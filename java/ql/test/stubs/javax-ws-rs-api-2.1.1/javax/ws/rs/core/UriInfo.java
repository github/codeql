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
import java.net.URI;
import java.util.List;

public interface UriInfo {
    public String getPath();

    public String getPath(boolean decode);

    public List<PathSegment> getPathSegments();

    public List<PathSegment> getPathSegments(boolean decode);

    public URI getRequestUri();

    public UriBuilder getRequestUriBuilder();

    public URI getAbsolutePath();

    public UriBuilder getAbsolutePathBuilder();

    public URI getBaseUri();

    public UriBuilder getBaseUriBuilder();

    public MultivaluedMap<String, String> getPathParameters();

    public MultivaluedMap<String, String> getPathParameters(boolean decode);

    public MultivaluedMap<String, String> getQueryParameters();

    public MultivaluedMap<String, String> getQueryParameters(boolean decode);

    public List<String> getMatchedURIs();

    public List<String> getMatchedURIs(boolean decode);

    public List<Object> getMatchedResources();

    public URI resolve(URI uri);

    public URI relativize(URI uri);

}
