public class NettyRequestSplitting {
    // BAD: Disables the internal request splitting verification
    private final DefaultHttpHeaders badHeaders = new DefaultHttpHeaders(false);

    // GOOD: Verifies headers passed don't contain CRLF characters
    private final DefaultHttpHeaders goodHeaders = new DefaultHttpHeaders();

    // BAD: Disables the internal request splitting verification
    private final DefaultHttpRequest badRequest = new DefaultHttpRequest(httpVersion, method, uri, false);

    // GOOD: Verifies headers passed don't contain CRLF characters
    private final DefaultHttpRequest goodResponse = new DefaultHttpRequest(httpVersion, method, uri);
}
