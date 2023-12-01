// Generated automatically from javax.crypto.KeyGenerator for testing purposes

package javax.crypto;

import java.security.Provider;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;
import javax.crypto.KeyGeneratorSpi;
import javax.crypto.SecretKey;

public class KeyGenerator
{
    protected KeyGenerator() {}
    protected KeyGenerator(KeyGeneratorSpi p0, Provider p1, String p2){}
    public final Provider getProvider(){ return null; }
    public final SecretKey generateKey(){ return null; }
    public final String getAlgorithm(){ return null; }
    public final void init(AlgorithmParameterSpec p0){}
    public final void init(AlgorithmParameterSpec p0, SecureRandom p1){}
    public final void init(SecureRandom p0){}
    public final void init(int p0){}
    public final void init(int p0, SecureRandom p1){}
    public static KeyGenerator getInstance(String p0){ return null; }
    public static KeyGenerator getInstance(String p0, Provider p1){ return null; }
    public static KeyGenerator getInstance(String p0, String p1){ return null; }
}
