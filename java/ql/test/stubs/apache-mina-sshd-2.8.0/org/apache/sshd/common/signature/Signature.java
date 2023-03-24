// Generated automatically from org.apache.sshd.common.signature.Signature for testing purposes

package org.apache.sshd.common.signature;

import java.security.PrivateKey;
import java.security.PublicKey;
import org.apache.sshd.common.AlgorithmNameProvider;
import org.apache.sshd.common.session.SessionContext;

public interface Signature extends AlgorithmNameProvider
{
    boolean verify(SessionContext p0, byte[] p1);
    byte[] sign(SessionContext p0);
    default String getSshAlgorithmName(String p0){ return null; }
    default void update(SessionContext p0, byte[] p1){}
    void initSigner(SessionContext p0, PrivateKey p1);
    void initVerifier(SessionContext p0, PublicKey p1);
    void update(SessionContext p0, byte[] p1, int p2, int p3);
}
