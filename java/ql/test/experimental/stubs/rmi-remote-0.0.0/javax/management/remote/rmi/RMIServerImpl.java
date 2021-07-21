package javax.management.remote.rmi;

import java.io.Closeable;
import java.rmi.Remote;

public class RMIServerImpl implements Closeable, RMIServer { 

  public void close() { }
  public String getVersion() { return null; }
  public RMIConnection newClient(Object credentials) { return null; }

}
