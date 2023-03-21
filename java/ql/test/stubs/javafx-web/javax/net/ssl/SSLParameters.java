// Generated automatically from javax.net.ssl.SSLParameters for testing purposes

package javax.net.ssl;

import java.security.AlgorithmConstraints;
import java.util.Collection;
import java.util.List;
import javax.net.ssl.SNIMatcher;
import javax.net.ssl.SNIServerName;

public class SSLParameters
{
    public AlgorithmConstraints getAlgorithmConstraints(){ return null; }
    public SSLParameters(){}
    public SSLParameters(String[] p0){}
    public SSLParameters(String[] p0, String[] p1){}
    public String getEndpointIdentificationAlgorithm(){ return null; }
    public String[] getApplicationProtocols(){ return null; }
    public String[] getCipherSuites(){ return null; }
    public String[] getProtocols(){ return null; }
    public String[] getSignatureSchemes(){ return null; }
    public boolean getEnableRetransmissions(){ return false; }
    public boolean getNeedClientAuth(){ return false; }
    public boolean getWantClientAuth(){ return false; }
    public final Collection<SNIMatcher> getSNIMatchers(){ return null; }
    public final List<SNIServerName> getServerNames(){ return null; }
    public final boolean getUseCipherSuitesOrder(){ return false; }
    public final void setSNIMatchers(Collection<SNIMatcher> p0){}
    public final void setServerNames(List<SNIServerName> p0){}
    public final void setUseCipherSuitesOrder(boolean p0){}
    public int getMaximumPacketSize(){ return 0; }
    public void setAlgorithmConstraints(AlgorithmConstraints p0){}
    public void setApplicationProtocols(String[] p0){}
    public void setCipherSuites(String[] p0){}
    public void setEnableRetransmissions(boolean p0){}
    public void setEndpointIdentificationAlgorithm(String p0){}
    public void setMaximumPacketSize(int p0){}
    public void setNeedClientAuth(boolean p0){}
    public void setProtocols(String[] p0){}
    public void setSignatureSchemes(String[] p0){}
    public void setWantClientAuth(boolean p0){}
}
