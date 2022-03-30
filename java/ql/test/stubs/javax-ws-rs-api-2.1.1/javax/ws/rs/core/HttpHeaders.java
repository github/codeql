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
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public interface HttpHeaders {
    public List<String> getRequestHeader(String name);

    public String getHeaderString(String name);

    public MultivaluedMap<String, String> getRequestHeaders();

    public List<MediaType> getAcceptableMediaTypes();

    public List<Locale> getAcceptableLanguages();

    public MediaType getMediaType();

    public Locale getLanguage();

    public Map<String, Cookie> getCookies();

    public Date getDate();

    public int getLength();

}
