// Generated automatically from okhttp3.internal.http2.ErrorCode for testing purposes

package okhttp3.internal.http2;


public enum ErrorCode
{
    CANCEL, COMPRESSION_ERROR, CONNECT_ERROR, ENHANCE_YOUR_CALM, FLOW_CONTROL_ERROR, FRAME_SIZE_ERROR, HTTP_1_1_REQUIRED, INADEQUATE_SECURITY, INTERNAL_ERROR, NO_ERROR, PROTOCOL_ERROR, REFUSED_STREAM, SETTINGS_TIMEOUT, STREAM_CLOSED;
    private ErrorCode() {}
    public final int getHttpCode(){ return 0; }
    public static ErrorCode.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final ErrorCode fromHttp2(int p0){ return null; }
    }
}
