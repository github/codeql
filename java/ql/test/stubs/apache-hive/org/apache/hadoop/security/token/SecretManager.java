// Generated automatically from org.apache.hadoop.security.token.SecretManager for testing purposes

package org.apache.hadoop.security.token;

import java.io.IOException;
import javax.crypto.SecretKey;
import org.apache.hadoop.security.token.TokenIdentifier;

abstract public class SecretManager<T extends TokenIdentifier>
{
    protected SecretKey generateSecret(){ return null; }
    protected abstract byte[] createPassword(T p0);
    protected static SecretKey createSecretKey(byte[] p0){ return null; }
    protected static byte[] createPassword(byte[] p0, SecretKey p1){ return null; }
    public SecretManager(){}
    public abstract T createIdentifier();
    public abstract byte[] retrievePassword(T p0);
    public byte[] retriableRetrievePassword(T p0){ return null; }
    public void checkAvailableForRead(){}
    static public class InvalidToken extends IOException
    {
        protected InvalidToken() {}
        public InvalidToken(String p0){}
    }
}
