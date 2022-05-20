import io.netty.handler.codec.http.DefaultHttpHeaders;

public class ResponseSplitting {
    // BAD: Disables the internal response splitting verification
    private final DefaultHttpHeaders badHeaders = new DefaultHttpHeaders(false);

    // GOOD: Verifies headers passed don't contain CRLF characters
    private final DefaultHttpHeaders goodHeaders = new DefaultHttpHeaders();

    // BAD: Disables the internal response splitting verification
    private final DefaultHttpResponse badResponse = new DefaultHttpResponse(version, httpResponseStatus, false);

    // GOOD: Verifies headers passed don't contain CRLF characters
    private final DefaultHttpResponse goodResponse = new DefaultHttpResponse(version, httpResponseStatus);
}
