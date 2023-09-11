import play.mvc.Http;

public class PlayMvc {

    private Http.Request request;
    private Http.RequestHeader header;

    private static void sink(Object o) {}

    public void test() throws Exception {
        sink(request.body()); // $ hasRemoteValueFlow
        sink(header.cookie(null)); // $ hasRemoteValueFlow
        sink(header.cookies()); // $ hasRemoteValueFlow
        sink(header.getHeader(null)); // $ hasRemoteValueFlow
        sink(header.getHeaders()); // $ hasRemoteValueFlow
        sink(header.getQueryString(null)); // $ hasRemoteValueFlow
        sink(header.header(null)); // $ hasRemoteValueFlow
        sink(header.headers()); // $ hasRemoteValueFlow
        sink(header.host()); // $ hasRemoteValueFlow
        sink(header.path()); // $ hasRemoteValueFlow
        sink(header.queryString()); // $ hasRemoteValueFlow
        sink(header.remoteAddress()); // $ hasRemoteValueFlow
        sink(header.uri()); // $ hasRemoteValueFlow
    }
}
