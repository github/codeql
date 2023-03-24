public class CorrectRmiInitialisation {
    public void initAndStartRmiServer(int port, String hostname, boolean local) {
        MBeanServerForwarder authzProxy = null;

        env.put("jmx.remote.x.daemon", "true");
        
        /* Restrict the login function to String Objects only (see CVE-2016-3427) */
        Map<String, Object> env = new HashMap<String, Object>();
        // For Java 10+
        String stringsOnlyFilter = "java.lang.String;!*"; // Deny everything but java.lang.String
        env.put(RMIConnectorServer.CREDENTIALS_FILTER_PATTERN, stringsOnlyFilter);
                
        /* Java 9 or below
        env.put("jmx.remote.rmi.server.credential.types",
                new String[] { String[].class.getName(), String.class.getName() });
        */
        
        int rmiPort = Integer.getInteger("com.sun.management.jmxremote.rmi.port", 0);
        RMIJRMPServerImpl server = new RMIJRMPServerImpl(rmiPort,
                (RMIClientSocketFactory) env.get(RMIConnectorServer.RMI_CLIENT_SOCKET_FACTORY_ATTRIBUTE),
                (RMIServerSocketFactory) env.get(RMIConnectorServer.RMI_SERVER_SOCKET_FACTORY_ATTRIBUTE), env);

        JMXServiceURL serviceURL = new JMXServiceURL("rmi", hostname, rmiPort);

        // Create RMI Server
        RMIConnectorServer jmxServer = new RMIConnectorServer(serviceURL, env, server,
                ManagementFactory.getPlatformMBeanServer());

        jmxServer.start();

    }
}
