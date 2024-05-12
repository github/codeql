package org.apache.cxf.resource;

public class URIResolver {
    public URIResolver() {}

    public URIResolver(String path) {}

    public URIResolver(String baseUriStr, String uriStr) {}

    public URIResolver(String baseUriStr, String uriStr, Class<?> calling) {}

    public void resolve(String baseUriStr, String uriStr, Class<?> callingCls) {}
}
