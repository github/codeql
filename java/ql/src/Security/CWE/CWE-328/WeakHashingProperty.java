import java.io.FileInputStream;
import java.util.Properties;
import java.security.MessageDigest;

Properties props = Properties.load(new FileInputStream("settings.properties"));

// BAD: the `hashAlgorithm` variable in `settings.properties` is `MD5` which is
// a weak hashing algorithm.
MessageDigest.getInstance(props.getProperty("hashAlgorithm"));
