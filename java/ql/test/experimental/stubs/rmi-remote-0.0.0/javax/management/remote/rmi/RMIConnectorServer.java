package javax.management.remote.rmi;

import java.util.Map;

import javax.management.remote.JMXConnectorServer;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXServiceURL;
import javax.management.remote.MBeanServerForwarder;
import javax.management.MBeanServer;

// Note this is a partial stub sufficient to the needs of tests for CWE-665
public class RMIConnectorServer extends JMXConnectorServer {

  public RMIConnectorServer(JMXServiceURL url, Map<String,?> environment) { }
  public RMIConnectorServer(JMXServiceURL url, Map<String,?> environment, MBeanServer mbeanServer) { }
  public RMIConnectorServer(JMXServiceURL url, Map<String,?> environment, RMIServerImpl rmiServerImpl, MBeanServer mbeanServer) { }

  public static String CREDENTIAL_TYPES	= "";
  public static String CREDENTIALS_FILTER_PATTERN = "";
  public static String JNDI_REBIND_ATTRIBUTE = "";
  public static String RMI_CLIENT_SOCKET_FACTORY_ATTRIBUTE = "";
  public static String RMI_SERVER_SOCKET_FACTORY_ATTRIBUTE = "";
  public static String SERIAL_FILTER_PATTERN = "";

  public Map<String,?> getAttributes() { return null; }
  public JMXServiceURL getAddress() { return null; }
  public String[] getConnectionIds() { return null; }
  public boolean isActive() { return true; }
  public void setMBeanServerForwarder(MBeanServerForwarder mbsf) { }
  public void start() { }
  public void stop() { }
  public JMXConnector toJMXConnector(Map<String,?> env) { return null; }

}
