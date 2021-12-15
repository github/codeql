import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.rmi.registry.LocateRegistry;
import java.util.HashMap;
import java.util.Map;

import javax.management.MBeanServer;
import javax.management.remote.JMXConnectorServerFactory;
import javax.management.remote.JMXServiceURL;

public class CorrectJmxInitialisation {

    public void initAndStartJmxServer() throws IOException{
        int jmxPort = 1919;
        LocateRegistry.createRegistry(jmxPort);

        /* Restrict the login function to String Objects only (see CVE-2016-3427) */
        Map<String, Object> env = new HashMap<String, Object>();
        // For Java 10+
        String stringsOnlyFilter = "java.lang.String;!*"; // Deny everything but java.lang.String
        env.put(RMIConnectorServer.CREDENTIALS_FILTER_PATTERN, stringsOnlyFilter);
                
        /* Java 9 or below:
        env.put("jmx.remote.rmi.server.credential.types",
                new String[] { String[].class.getName(), String.class.getName() });
        */
        
        MBeanServer beanServer = ManagementFactory.getPlatformMBeanServer();

        JMXServiceURL jmxUrl = new JMXServiceURL("service:jmx:rmi:///jndi/rmi://localhost:" + jmxPort + "/jmxrmi");

        // Create JMXConnectorServer in a secure manner
        javax.management.remote.JMXConnectorServer connectorServer = JMXConnectorServerFactory
                .newJMXConnectorServer(jmxUrl, env, beanServer);

        connectorServer.start();
    }
}
