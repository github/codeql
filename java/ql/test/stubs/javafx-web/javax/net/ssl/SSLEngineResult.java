// Generated automatically from javax.net.ssl.SSLEngineResult for testing purposes

package javax.net.ssl;


public class SSLEngineResult
{
    protected SSLEngineResult() {}
    public SSLEngineResult(SSLEngineResult.Status p0, SSLEngineResult.HandshakeStatus p1, int p2, int p3){}
    public SSLEngineResult(SSLEngineResult.Status p0, SSLEngineResult.HandshakeStatus p1, int p2, int p3, long p4){}
    public String toString(){ return null; }
    public final SSLEngineResult.HandshakeStatus getHandshakeStatus(){ return null; }
    public final SSLEngineResult.Status getStatus(){ return null; }
    public final int bytesConsumed(){ return 0; }
    public final int bytesProduced(){ return 0; }
    public final long sequenceNumber(){ return 0; }
    static public enum HandshakeStatus
    {
        FINISHED, NEED_TASK, NEED_UNWRAP, NEED_UNWRAP_AGAIN, NEED_WRAP, NOT_HANDSHAKING;
        private HandshakeStatus() {}
    }
    static public enum Status
    {
        BUFFER_OVERFLOW, BUFFER_UNDERFLOW, CLOSED, OK;
        private Status() {}
    }
}
