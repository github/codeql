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
import javax.ws.rs.core.Configurable;
import javax.ws.rs.core.Link;
import javax.ws.rs.core.UriBuilder;
// import javax.net.ssl.HostnameVerifier;
// import javax.net.ssl.SSLContext;

public interface Client extends Configurable<Client> {
    public void close();

    public WebTarget target(String uri);

    public WebTarget target(URI uri);

    public WebTarget target(UriBuilder uriBuilder);

    public WebTarget target(Link link);

    // public Invocation.Builder invocation(Link link);

    // public SSLContext getSslContext();

    // public HostnameVerifier getHostnameVerifier();

}
