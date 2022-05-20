
package org.apache.shiro.crypto;

import java.io.InputStream;
import java.io.OutputStream;

public interface CipherService {

    void decrypt(InputStream var1, OutputStream var2, byte[] var3) throws Exception;

    void encrypt(InputStream var1, OutputStream var2, byte[] var3) throws Exception;
}
