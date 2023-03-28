// Generated automatically from javax.security.sasl.SaslServer for testing purposes

package javax.security.sasl;


public interface SaslServer
{
    Object getNegotiatedProperty(String p0);
    String getAuthorizationID();
    String getMechanismName();
    boolean isComplete();
    byte[] evaluateResponse(byte[] p0);
    byte[] unwrap(byte[] p0, int p1, int p2);
    byte[] wrap(byte[] p0, int p1, int p2);
    void dispose();
}
