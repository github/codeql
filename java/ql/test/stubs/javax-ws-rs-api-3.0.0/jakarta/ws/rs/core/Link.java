/*
 * Copyright (c) 2011, 2020 Oracle and/or its affiliates. All rights reserved.
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
import java.net.URI;
import java.util.List;
import java.util.Map;
// import javax.xml.namespace.QName;
// import jakarta.xml.bind.annotation.adapters.XmlAdapter;

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

    public static Link valueOf(final String value) {
      return null;
    }

    public static Builder fromUri(final URI uri) {
      return null;
    }

    public static Builder fromUri(final String uri) {
      return null;
    }

    public static Builder fromUriBuilder(final UriBuilder uriBuilder) {
      return null;
    }

    public static Builder fromLink(final Link link) {
      return null;
    }

    public static Builder fromPath(final String path) {
      return null;
    }

    public static Builder fromResource(final Class<?> resource) {
      return null;
    }

    public static Builder fromMethod(final Class<?> resource, final String method) {
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

        public JaxbLink(final URI uri) {
        }

        // public JaxbLink(final URI uri, final Map<QName, Object> params) {
        // }

        public URI getUri() {
          return null;
        }

        // public Map<QName, Object> getParams() {
        //   return null;
        // }

        @Override
        public boolean equals(final Object o) {
          return false;
        }

        @Override
        public int hashCode() {
          return 0;
        }

    }
    // public static class JaxbAdapter extends XmlAdapter<JaxbLink, Link> {
    //     @Override
    //     public Link unmarshal(final JaxbLink v) {
    //       return null;
    //     }

    //     @Override
    //     public JaxbLink marshal(final Link v) {
    //       return null;
    //     }

    // }
}
