package javax.ws.rs.core;

public abstract class Link {

    public static final java.lang.String TITLE = "title";

    public static final java.lang.String REL = "rel";

    public static final java.lang.String TYPE = "type";

    public Link() {
    }

    public abstract java.net.URI getUri();

    public abstract javax.ws.rs.core.UriBuilder getUriBuilder();

    public abstract java.lang.String getRel();

    public abstract java.util.List<java.lang.String> getRels();

    public abstract java.lang.String getTitle();

    public abstract java.lang.String getType();

    public abstract java.util.Map<java.lang.String, java.lang.String> getParams();

    public abstract java.lang.String toString();

    public static javax.ws.rs.core.Link valueOf(java.lang.String value) {
        return null;
    }

    // public static javax.ws.rs.core.Link.Builder fromUri(java.net.URI uri) {
    //     return null;
    // }

    // public static javax.ws.rs.core.Link.Builder fromUri(java.lang.String uri) {
    //     return null;
    // }

    // public static javax.ws.rs.core.Link.Builder fromUriBuilder(javax.ws.rs.core.UriBuilder uriBuilder) {
    //     return null;
    // }

    // public static javax.ws.rs.core.Link.Builder fromLink(javax.ws.rs.core.Link link) {
    //     return null;
    // }

    // public static javax.ws.rs.core.Link.Builder fromPath(java.lang.String path) {
    //     return null;
    // }

    // public static javax.ws.rs.core.Link.Builder fromResource(java.lang.Class<?> resource) {
    //     return null;
    // }

    // public static javax.ws.rs.core.Link.Builder fromMethod(java.lang.Class<?> resource, java.lang.String method) {
    //     return null;
    // }
}