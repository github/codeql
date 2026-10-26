import java.security.NoSuchAlgorithmException;

public interface HASH {
  void init() throws NoSuchAlgorithmException;

  int getBlockSize();

  void update(byte[] foo, int start, int len) throws NoSuchAlgorithmException;

  byte[] digest() throws NoSuchAlgorithmException;
}
