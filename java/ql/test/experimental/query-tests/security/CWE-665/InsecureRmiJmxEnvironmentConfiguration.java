import java.io.IOException;
import javax.management.remote.JMXConnectorServerFactory;
import javax.management.remote.rmi.RMIConnectorServer;

import java.util.HashMap;
import java.util.Map;

public class InsecureRmiJmxEnvironmentConfiguration {

  public void initInsecureJmxDueToNullEnv() throws IOException {
    // Bad initializing env (arg1) with null
    JMXConnectorServerFactory.newJMXConnectorServer(null, null, null);
  }

  public void initInsecureRmiDueToNullEnv() throws IOException {
    // Bad initializing env (arg1) with null
    new RMIConnectorServer(null, null, null, null);
  }

  public void initInsecureRmiDueToMissingEnvKeyValue() throws IOException {
    // Bad initializing env (arg1) with missing
    // "jmx.remote.rmi.server.credential.types"
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    new RMIConnectorServer(null, env, null, null);
  }

  public void initInsecureJmxDueToMissingEnvKeyValue() throws IOException {
    // Bad initializing env (arg1) with missing
    // "jmx.remote.rmi.server.credential.types"
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    JMXConnectorServerFactory.newJMXConnectorServer(null, env, null);
  }

  public void secureJmxConnnectorServer() throws IOException {
    // Good
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    env.put("jmx.remote.rmi.server.credential.types",
        new String[] { String[].class.getName(), String.class.getName() });
    JMXConnectorServerFactory.newJMXConnectorServer(null, env, null);
  }

  public void secureRmiConnnectorServer() throws IOException {
    // Good
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    env.put("jmx.remote.rmi.server.credential.types",
        new String[] { String[].class.getName(), String.class.getName() });
    new RMIConnectorServer(null, env, null, null);
  }

  public void secureeJmxConnectorServerConstants1() throws IOException {
    // Good
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    env.put(RMIConnectorServer.CREDENTIALS_FILTER_PATTERN, "java.lang.String;!*"); // Deny everything but
                                                                                   // java.lang.String
    JMXConnectorServerFactory.newJMXConnectorServer(null, env, null);
  }

  public void secureeRmiConnectorServerConstants1() throws IOException {
    // Good
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    String stringsOnlyFilter = "java.lang.String;!*"; // Deny everything but java.lang.String
    env.put(RMIConnectorServer.CREDENTIALS_FILTER_PATTERN, stringsOnlyFilter);
    new RMIConnectorServer(null, env, null, null);
  }

  public void secureJmxConnectorServerConstants2() throws IOException {
    // Good
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    env.put("jmx.remote.rmi.server.credentials.filter.pattern", "java.lang.String;!*"); // Deny everything but
                                                                                        // java.lang.String
    JMXConnectorServerFactory.newJMXConnectorServer(null, env, null);
  }

  public void secureRmiConnectorServerConstants2() throws IOException {
    // Good
    Map<String, Object> env = new HashMap<>();
    env.put("jmx.remote.x.daemon", "true");
    String stringsOnlyFilter = "java.lang.String;!*"; // Deny everything but java.lang.String
    env.put("jmx.remote.rmi.server.credentials.filter.pattern", stringsOnlyFilter);
    new RMIConnectorServer(null, env, null, null);
  }
}
