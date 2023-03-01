// Generated automatically from javax.security.sasl.SaslClient for testing purposes

package javax.security.sasl;


public interface SaslClient
{
    Object getNegotiatedProperty(String p0);
    String getMechanismName();
    boolean hasInitialResponse();
    boolean isComplete();
    byte[] evaluateChallenge(byte[] p0);
    byte[] unwrap(byte[] p0, int p1, int p2);
    byte[] wrap(byte[] p0, int p1, int p2);
    void dispose();
}
