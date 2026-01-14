import static com.couchbase.client.java.ClusterOptions.clusterOptions;

import com.couchbase.client.core.env.CertificateAuthenticator;
import com.couchbase.client.core.env.PasswordAuthenticator;
import com.couchbase.client.core.env.UsernameAndPassword;
import com.couchbase.client.java.Cluster;
import java.util.function.Supplier;

public class HardcodedCouchBaseCredentials {
  public static void test() {
    // com.couchbase.client.core.env.CertificateAuthenticator sinks
    CertificateAuthenticator.fromKey(null, "keyPassword", null); // $ HardcodedCredentialsApiCall
    CertificateAuthenticator.fromKeyStore(
        null, "keyStorePassword", null); // $ HardcodedCredentialsApiCall
    CertificateAuthenticator.fromKeyStore(
        null, "keyStorePassword"); // $ HardcodedCredentialsApiCall

    // com.couchbase.client.core.env.PasswordAuthenticator sinks
    PasswordAuthenticator.create(
        "Administrator", // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
        "password"); // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
    PasswordAuthenticator.ldapCompatible(
        "Administrator", // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
        "password"); // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall

    // com.couchbase.client.core.env.PasswordAuthenticator$Builder sinks
    PasswordAuthenticator.builder(
        "Administrator", // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
        "password"); // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
    PasswordAuthenticator.builder()
        .username("Administrator") // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
        .password("password"); // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
    PasswordAuthenticator.builder(
        (Supplier<UsernameAndPassword>)
            () -> new UsernameAndPassword(
                "Administrator", // $ HardcodedCredentialsSourceCall $ MISSING: HardcodedCredentialsApiCall
                "password")); // $ HardcodedCredentialsSourceCall $ MISSING: HardcodedCredentialsApiCall
    PasswordAuthenticator.builder()
        .username(
            (Supplier<String>)
                () -> {
                  return "Administrator"; // $ MISSING: HardcodedCredentialsApiCall
                }) 
        .password(
            (Supplier<String>)
                () -> {
                  return "password"; // $ MISSING: HardcodedCredentialsApiCall
                }); 

    // com.couchbase.client.java.Cluster sinks
    Cluster.connect(
        "127.0.0.1",
        "Administrator", // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
        "password"); // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall

    // com.couchbase.client.java.ClusterOptions sinks
    Cluster.connect(
        "127.0.0.1",
        clusterOptions(
            "Administrator", // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
            "password")); // $ HardcodedCredentialsSourceCall $ HardcodedCredentialsApiCall
  }
}
