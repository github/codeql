import io.netty.handler.codec.http.DefaultHttpHeaders;

public class ResponseSplitting {
    // BAD: Disables the internal response splitting verification
    private final DefaultHttpHeaders badHeaders = new DefaultHttpHeaders(false);

    // GOOD: Verifies headers passed don't contain CLRF characters
    private final DefaultHttpHeaders badHeaders = new DefaultHttpHeaders();
}
