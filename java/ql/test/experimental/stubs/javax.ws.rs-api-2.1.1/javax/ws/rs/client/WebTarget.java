/*
 * Copyright (c) 2011, 2017 Oracle and/or its affiliates. All rights reserved.
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

package javax.ws.rs.client;

import java.net.URI;
import java.util.Map;

import javax.ws.rs.core.Configurable;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.UriBuilder;

public interface WebTarget extends Configurable<WebTarget> {
    public URI getUri();
    public UriBuilder getUriBuilder();
    public WebTarget path(String path);
    public WebTarget resolveTemplate(String name, Object value);
    public WebTarget resolveTemplate(String name, Object value, boolean encodeSlashInPath);
    public WebTarget resolveTemplateFromEncoded(String name, Object value);
    public WebTarget resolveTemplates(Map<String, Object> templateValues);
    public WebTarget resolveTemplates(Map<String, Object> templateValues, boolean encodeSlashInPath);
    public WebTarget resolveTemplatesFromEncoded(Map<String, Object> templateValues);
    public WebTarget matrixParam(String name, Object... values);
    public WebTarget queryParam(String name, Object... values);
    public Invocation.Builder request();
    public Invocation.Builder request(String... acceptedResponseTypes);
    public Invocation.Builder request(MediaType... acceptedResponseTypes);
}
