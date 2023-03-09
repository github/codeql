// Generated automatically from org.apache.thrift.transport.TSaslServerTransport for testing purposes

package org.apache.thrift.transport;

import java.util.Map;
import javax.security.auth.callback.CallbackHandler;
import org.apache.thrift.transport.TSaslTransport;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportFactory;

public class TSaslServerTransport extends TSaslTransport
{
    protected TSaslServerTransport() {}
    protected TSaslTransport.SaslRole getRole(){ return null; }
    protected void handleSaslStartMessage(){}
    public TSaslServerTransport(String p0, String p1, String p2, Map<String, String> p3, CallbackHandler p4, TTransport p5){}
    public TSaslServerTransport(TTransport p0){}
    public void addServerDefinition(String p0, String p1, String p2, Map<String, String> p3, CallbackHandler p4){}
    static public class Factory extends TTransportFactory
    {
        public Factory(){}
        public Factory(String p0, String p1, String p2, Map<String, String> p3, CallbackHandler p4){}
        public TTransport getTransport(TTransport p0){ return null; }
        public void addServerDefinition(String p0, String p1, String p2, Map<String, String> p3, CallbackHandler p4){}
    }
}
