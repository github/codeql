// Generated automatically from org.apache.sshd.common.mac.MacInformation for testing purposes

package org.apache.sshd.common.mac;

import org.apache.sshd.common.AlgorithmNameProvider;

public interface MacInformation extends AlgorithmNameProvider
{
    default boolean isEncryptThenMac(){ return false; }
    int getBlockSize();
    int getDefaultBlockSize();
}
