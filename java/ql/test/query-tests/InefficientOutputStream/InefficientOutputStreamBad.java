import java.io.*;
import java.security.*;
import java.util.*;

public class InefficientOutputStreamBad extends OutputStream {
	private DigestOutputStream digest;
	private byte[] expectedMD5;
	
	public InefficientOutputStreamBad(File file, byte[] expectedMD5) throws IOException, NoSuchAlgorithmException {
			this.expectedMD5 = expectedMD5;
			digest = new DigestOutputStream(new FileOutputStream(file), MessageDigest.getInstance("MD5"));
		}

	@Override
	public void write(int b) throws IOException {
		digest.write(b);
	}

	@Override
	public void close() throws IOException {
		super.close();

		digest.close();
		byte[] md5 = digest.getMessageDigest().digest();
		if (expectedMD5 != null && !Arrays.equals(expectedMD5, md5)) {
			throw new InternalError();
		}
	}
}
