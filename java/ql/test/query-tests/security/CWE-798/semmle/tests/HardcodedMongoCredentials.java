import com.mongodb.MongoCredential;

public class HardcodedMongoCredentials {
  public static void test() {
    MongoCredential.createCredential("Username", "blah", "password".toCharArray());
    MongoCredential.createMongoCRCredential("Username", "blah", "password".toCharArray());
    MongoCredential.createPlainCredential("Username", "blah", "password".toCharArray());
    MongoCredential.createScramSha1Credential("Username", "blah", "password".toCharArray());
    MongoCredential.createGSSAPICredential("key");
    MongoCredential.createMongoX509Credential("key");
  }
}