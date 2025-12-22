import static com.couchbase.client.java.ClusterOptions.clusterOptions;

import com.couchbase.client.core.env.Authenticator;
import com.couchbase.client.core.env.CertificateAuthenticator;
import com.couchbase.client.core.env.PasswordAuthenticator;
import com.couchbase.client.java.Cluster;

public class HardcodedCouchBaseCredentials {
  public static void test() {
    Cluster cluster1 =
        Cluster.connect(
            "127.0.0.1",
            "Administrator", // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
            "password"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    Cluster cluster2 =
        Cluster.connect(
            "127.0.0.1",
            clusterOptions(
                "Administrator", // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
                "password")); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    PasswordAuthenticator authenticator1 =
        PasswordAuthenticator.builder()
            .username(
                "Administrator") // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
            .password("password") // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
            .onlyEnablePlainSaslMechanism()
            .build();

    Authenticator authenticator2 =
        CertificateAuthenticator.fromKeyStore(
            null,
            "keyStorePassword"); // $ HardcodedCredentialsApiCall
    Cluster cluster = Cluster.connect("127.0.0.1", clusterOptions(authenticator2));
  }
}