// Generated automatically from org.apache.thrift.transport.TTransportException for testing purposes

package org.apache.thrift.transport;

import org.apache.thrift.TException;

public class TTransportException extends TException
{
    protected int type_ = 0;
    public TTransportException(){}
    public TTransportException(String p0){}
    public TTransportException(String p0, Throwable p1){}
    public TTransportException(Throwable p0){}
    public TTransportException(int p0){}
    public TTransportException(int p0, String p1){}
    public TTransportException(int p0, String p1, Throwable p2){}
    public TTransportException(int p0, Throwable p1){}
    public int getType(){ return 0; }
    public static int ALREADY_OPEN = 0;
    public static int END_OF_FILE = 0;
    public static int NOT_OPEN = 0;
    public static int TIMED_OUT = 0;
    public static int UNKNOWN = 0;
}
