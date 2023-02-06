// Generated automatically from org.apache.sshd.common.channel.PtyChannelConfigurationMutator for testing purposes

package org.apache.sshd.common.channel;

import java.util.Map;
import org.apache.sshd.common.channel.PtyChannelConfigurationHolder;
import org.apache.sshd.common.channel.PtyMode;

public interface PtyChannelConfigurationMutator extends PtyChannelConfigurationHolder
{
    static <M extends PtyChannelConfigurationMutator> M copyConfiguration(PtyChannelConfigurationHolder p0, M p1){ return null; }
    static <M extends PtyChannelConfigurationMutator> M setupSensitiveDefaultPtyConfiguration(M p0){ return null; }
    void setPtyColumns(int p0);
    void setPtyHeight(int p0);
    void setPtyLines(int p0);
    void setPtyModes(Map<PtyMode, Integer> p0);
    void setPtyType(String p0);
    void setPtyWidth(int p0);
}
