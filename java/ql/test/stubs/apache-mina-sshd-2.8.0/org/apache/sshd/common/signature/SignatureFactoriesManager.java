// Generated automatically from org.apache.sshd.common.signature.SignatureFactoriesManager for testing purposes

package org.apache.sshd.common.signature;

import java.util.Collection;
import java.util.List;
import org.apache.sshd.common.NamedFactory;
import org.apache.sshd.common.signature.Signature;
import org.apache.sshd.common.signature.SignatureFactoriesHolder;

public interface SignatureFactoriesManager extends SignatureFactoriesHolder
{
    default void setSignatureFactoriesNameList(String p0){}
    default void setSignatureFactoriesNames(Collection<String> p0){}
    default void setSignatureFactoriesNames(String... p0){}
    static List<NamedFactory<Signature>> getSignatureFactories(SignatureFactoriesManager p0){ return null; }
    static List<NamedFactory<Signature>> resolveSignatureFactories(SignatureFactoriesManager p0, SignatureFactoriesManager p1){ return null; }
    void setSignatureFactories(List<NamedFactory<Signature>> p0);
}
