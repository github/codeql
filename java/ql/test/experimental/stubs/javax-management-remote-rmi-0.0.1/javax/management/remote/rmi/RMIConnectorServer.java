package javax.management.remote.rmi;

import java.io.IOException;
import java.util.Map;
import java.io.IOException;
import javax.management.remote.JMXConnectorServer;
import javax.management.remote.JMXServiceURL;
import javax.management.MBeanServer;
import javax.management.remote.rmi.RMIServerImpl;
//import javax.management.remote.JMXConnectorServer;

//public class RMIConnectorServerTEST extends JMXConnectorServer{
public class RMIConnectorServer extends java.lang.Object {

    public static final String CREDENTIALS_FILTER_PATTERN = "jmx.remote.rmi.server.credentials.filter.pattern";

    public RMIConnectorServer(JMXServiceURL url, Map<String, ?> environment) throws IOException {
        // stub;
    }

    public RMIConnectorServer(JMXServiceURL url, Map<String, ?> environment, MBeanServer mbeanServer)
            throws IOException {
        // stub;
    }

    public RMIConnectorServer(JMXServiceURL url, Map<String, ?> environment, RMIServerImpl rmiServerImpl,
            MBeanServer mbeanServer) throws IOException {
        // stub;
    }
}
