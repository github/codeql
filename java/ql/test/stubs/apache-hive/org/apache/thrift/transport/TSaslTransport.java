// Generated automatically from org.apache.thrift.transport.TSaslTransport for testing purposes

package org.apache.thrift.transport;

import javax.security.sasl.SaslClient;
import javax.security.sasl.SaslServer;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;

abstract class TSaslTransport extends TTransport
{
    protected TSaslTransport() {}
    protected TSaslTransport(SaslClient p0, TTransport p1){}
    protected TSaslTransport(TTransport p0){}
    protected TSaslTransport.SaslResponse receiveSaslMessage(){ return null; }
    protected TTransport underlyingTransport = null;
    protected TTransportException sendAndThrowMessage(TSaslTransport.NegotiationStatus p0, String p1){ return null; }
    protected abstract TSaslTransport.SaslRole getRole();
    protected abstract void handleSaslStartMessage();
    protected int readLength(){ return 0; }
    protected static int DEFAULT_MAX_LENGTH = 0;
    protected static int MECHANISM_NAME_BYTES = 0;
    protected static int PAYLOAD_LENGTH_BYTES = 0;
    protected static int STATUS_BYTES = 0;
    protected void sendSaslMessage(TSaslTransport.NegotiationStatus p0, byte[] p1){}
    protected void setSaslServer(SaslServer p0){}
    protected void writeLength(int p0){}
    public SaslClient getSaslClient(){ return null; }
    public SaslServer getSaslServer(){ return null; }
    public TTransport getUnderlyingTransport(){ return null; }
    public boolean isOpen(){ return false; }
    public int read(byte[] p0, int p1, int p2){ return 0; }
    public void close(){}
    public void flush(){}
    public void open(){}
    public void write(byte[] p0, int p1, int p2){}
    static class SaslResponse
    {
        protected SaslResponse() {}
        public SaslResponse(TSaslTransport.NegotiationStatus p0, byte[] p1){}
        public TSaslTransport.NegotiationStatus status = null;
        public byte[] payload = null;
    }
    static enum NegotiationStatus
    {
        BAD, COMPLETE, ERROR, OK, START;
        private NegotiationStatus() {}
        public byte getValue(){ return 0; }
        public static TSaslTransport.NegotiationStatus byValue(byte p0){ return null; }
    }
    static enum SaslRole
    {
        CLIENT, SERVER;
        private SaslRole() {}
    }
}
