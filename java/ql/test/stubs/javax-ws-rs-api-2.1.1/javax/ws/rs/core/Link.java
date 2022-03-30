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

package javax.ws.rs.core;
import java.net.URI;
import java.util.List;
import java.util.Map;
// import javax.xml.bind.annotation.adapters.XmlAdapter;
// import javax.xml.namespace.QName;

public abstract class Link {
    public abstract URI getUri();

    public abstract UriBuilder getUriBuilder();

    public abstract String getRel();

    public abstract List<String> getRels();

    public abstract String getTitle();

    public abstract String getType();

    public abstract Map<String, String> getParams();

    @Override
    public abstract String toString();

    public static Link valueOf(String value) {
      return null;
    }

    public static Builder fromUri(URI uri) {
      return null;
    }

    public static Builder fromUri(String uri) {
      return null;
    }

    public static Builder fromUriBuilder(UriBuilder uriBuilder) {
      return null;
    }

    public static Builder fromLink(Link link) {
      return null;
    }

    public static Builder fromPath(String path) {
      return null;
    }

    public static Builder fromResource(Class<?> resource) {
      return null;
    }

    public static Builder fromMethod(Class<?> resource, String method) {
      return null;
    }

    public interface Builder {
        public Builder link(Link link);

        public Builder link(String link);

        public Builder uri(URI uri);

        public Builder uri(String uri);

        public Builder baseUri(URI uri);

        public Builder baseUri(String uri);

        public Builder uriBuilder(UriBuilder uriBuilder);

        public Builder rel(String rel);

        public Builder title(String title);

        public Builder type(String type);

        public Builder param(String name, String value);

        public Link build(Object... values);

        public Link buildRelativized(URI uri, Object... values);

    }
    public static class JaxbLink {
        public JaxbLink() {
        }

        public JaxbLink(URI uri) {
        }

        // public JaxbLink(URI uri, Map<QName, Object> params) {
        // }

        public URI getUri() {
          return null;
        }

        // public Map<QName, Object> getParams() {
        //   return null;
        // }

        @Override
        public boolean equals(Object o) {
          return false;
        }

        @Override
        public int hashCode() {
          return 0;
        }

    }
    // public static class JaxbAdapter extends XmlAdapter<JaxbLink, Link> {
    //     @Override
    //     public Link unmarshal(JaxbLink v) {
    //       return null;
    //     }

    //     @Override
    //     public JaxbLink marshal(Link v) {
    //       return null;
    //     }

    // }
}
