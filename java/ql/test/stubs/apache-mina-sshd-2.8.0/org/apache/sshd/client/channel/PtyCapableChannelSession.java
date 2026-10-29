// Generated automatically from org.apache.sshd.client.channel.PtyCapableChannelSession for testing purposes

package org.apache.sshd.client.channel;

import java.util.Map;
import org.apache.sshd.client.channel.ChannelSession;
import org.apache.sshd.common.channel.PtyChannelConfigurationHolder;
import org.apache.sshd.common.channel.PtyChannelConfigurationMutator;
import org.apache.sshd.common.channel.PtyMode;

public class PtyCapableChannelSession extends ChannelSession implements PtyChannelConfigurationMutator
{
    protected PtyCapableChannelSession() {}
    protected String resolvePtyType(PtyChannelConfigurationHolder p0){ return null; }
    protected void doOpenPty(){}
    public Map<PtyMode, Integer> getPtyModes(){ return null; }
    public Object setEnv(String p0, Object p1){ return null; }
    public PtyCapableChannelSession(boolean p0, PtyChannelConfigurationHolder p1, Map<String, ? extends Object> p2){}
    public String getPtyType(){ return null; }
    public boolean isAgentForwarding(){ return false; }
    public boolean isUsePty(){ return false; }
    public int getPtyColumns(){ return 0; }
    public int getPtyHeight(){ return 0; }
    public int getPtyLines(){ return 0; }
    public int getPtyWidth(){ return 0; }
    public void sendWindowChange(int p0, int p1){}
    public void sendWindowChange(int p0, int p1, int p2, int p3){}
    public void setAgentForwarding(boolean p0){}
    public void setPtyColumns(int p0){}
    public void setPtyHeight(int p0){}
    public void setPtyLines(int p0){}
    public void setPtyModes(Map<PtyMode, Integer> p0){}
    public void setPtyType(String p0){}
    public void setPtyWidth(int p0){}
    public void setUsePty(boolean p0){}
    public void setupSensibleDefaultPty(){}
}
