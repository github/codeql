// Generated automatically from org.apache.sshd.common.cipher.CipherInformation for testing purposes

package org.apache.sshd.common.cipher;

import org.apache.sshd.common.AlgorithmNameProvider;
import org.apache.sshd.common.keyprovider.KeySizeIndicator;

public interface CipherInformation extends AlgorithmNameProvider, KeySizeIndicator
{
    String getTransformation();
    int getAuthenticationTagSize();
    int getCipherBlockSize();
    int getIVSize();
    int getKdfSize();
}
