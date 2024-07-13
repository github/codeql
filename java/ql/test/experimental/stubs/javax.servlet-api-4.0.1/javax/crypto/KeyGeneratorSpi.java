// Generated automatically from javax.crypto.KeyGeneratorSpi for testing purposes

package javax.crypto;

import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;
import javax.crypto.SecretKey;

abstract public class KeyGeneratorSpi
{
    protected abstract SecretKey engineGenerateKey();
    protected abstract void engineInit(AlgorithmParameterSpec p0, SecureRandom p1);
    protected abstract void engineInit(SecureRandom p0);
    protected abstract void engineInit(int p0, SecureRandom p1);
    public KeyGeneratorSpi(){}
}
