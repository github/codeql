// Generated automatically from org.apache.sshd.common.signature.SignatureFactoriesHolder for testing purposes

package org.apache.sshd.common.signature;

import java.util.List;
import org.apache.sshd.common.NamedFactory;
import org.apache.sshd.common.signature.Signature;

public interface SignatureFactoriesHolder
{
    List<NamedFactory<Signature>> getSignatureFactories();
    default List<String> getSignatureFactoriesNames(){ return null; }
    default String getSignatureFactoriesNameList(){ return null; }
}
