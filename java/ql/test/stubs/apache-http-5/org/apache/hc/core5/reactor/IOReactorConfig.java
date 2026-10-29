// Generated automatically from org.apache.hc.core5.reactor.IOReactorConfig for testing purposes

package org.apache.hc.core5.reactor;

import java.net.SocketAddress;
import java.util.concurrent.TimeUnit;
import org.apache.hc.core5.util.TimeValue;
import org.apache.hc.core5.util.Timeout;

public class IOReactorConfig
{
    protected IOReactorConfig() {}
    public SocketAddress getSocksProxyAddress(){ return null; }
    public String getSocksProxyPassword(){ return null; }
    public String getSocksProxyUsername(){ return null; }
    public String toString(){ return null; }
    public TimeValue getSelectInterval(){ return null; }
    public TimeValue getSoLinger(){ return null; }
    public Timeout getSoTimeout(){ return null; }
    public boolean isSoKeepAlive(){ return false; }
    public boolean isSoKeepalive(){ return false; }
    public boolean isSoReuseAddress(){ return false; }
    public boolean isTcpNoDelay(){ return false; }
    public int getBacklogSize(){ return 0; }
    public int getIoThreadCount(){ return 0; }
    public int getRcvBufSize(){ return 0; }
    public int getSndBufSize(){ return 0; }
    public int getTrafficClass(){ return 0; }
    public static IOReactorConfig DEFAULT = null;
    public static IOReactorConfig.Builder copy(IOReactorConfig p0){ return null; }
    public static IOReactorConfig.Builder custom(){ return null; }
    static public class Builder
    {
        public IOReactorConfig build(){ return null; }
        public IOReactorConfig.Builder setBacklogSize(int p0){ return null; }
        public IOReactorConfig.Builder setIoThreadCount(int p0){ return null; }
        public IOReactorConfig.Builder setRcvBufSize(int p0){ return null; }
        public IOReactorConfig.Builder setSelectInterval(TimeValue p0){ return null; }
        public IOReactorConfig.Builder setSndBufSize(int p0){ return null; }
        public IOReactorConfig.Builder setSoKeepAlive(boolean p0){ return null; }
        public IOReactorConfig.Builder setSoLinger(TimeValue p0){ return null; }
        public IOReactorConfig.Builder setSoLinger(int p0, TimeUnit p1){ return null; }
        public IOReactorConfig.Builder setSoReuseAddress(boolean p0){ return null; }
        public IOReactorConfig.Builder setSoTimeout(Timeout p0){ return null; }
        public IOReactorConfig.Builder setSoTimeout(int p0, TimeUnit p1){ return null; }
        public IOReactorConfig.Builder setSocksProxyAddress(SocketAddress p0){ return null; }
        public IOReactorConfig.Builder setSocksProxyPassword(String p0){ return null; }
        public IOReactorConfig.Builder setSocksProxyUsername(String p0){ return null; }
        public IOReactorConfig.Builder setTcpNoDelay(boolean p0){ return null; }
        public IOReactorConfig.Builder setTrafficClass(int p0){ return null; }
        public static int getDefaultMaxIOThreadCount(){ return 0; }
        public static void setDefaultMaxIOThreadCount(int p0){}
    }
}
