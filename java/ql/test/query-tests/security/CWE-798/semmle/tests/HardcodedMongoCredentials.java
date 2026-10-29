import com.mongodb.MongoCredential;

public class HardcodedMongoCredentials {
  public static void test() {
    MongoCredential.createCredential("Username", "blah", "password".toCharArray()); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    MongoCredential.createMongoCRCredential("Username", "blah", "password".toCharArray()); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    MongoCredential.createPlainCredential("Username", "blah", "password".toCharArray()); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    MongoCredential.createScramSha1Credential("Username", "blah", "password".toCharArray()); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    MongoCredential.createGSSAPICredential("key"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
    MongoCredential.createMongoX509Credential("key"); // $ HardcodedCredentialsApiCall $ HardcodedCredentialsSourceCall
  }
}