import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA512 implements HASH {
  MessageDigest md;
  public int getBlockSize() {return 32;}
  public void init() throws NoSuchAlgorithmException {
    try { md = MessageDigest.getInstance("SHA-512"); }
    catch (Exception e){
      System.err.println(e);
    }
  }

  public void update(byte[] foo, int start, int len) throws NoSuchAlgorithmException {
    md.update(foo, start, len);
  }

  public byte[] digest() throws NoSuchAlgorithmException {
    return md.digest();
  }
}