// Generated automatically from com.auth0.jwt.algorithms.Algorithm for testing purposes

package com.auth0.jwt.algorithms;

import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.ECDSAKeyProvider;
import com.auth0.jwt.interfaces.RSAKeyProvider;
import java.security.interfaces.ECKey;
import java.security.interfaces.ECPrivateKey;
import java.security.interfaces.ECPublicKey;
import java.security.interfaces.RSAKey;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;

abstract public class Algorithm
{
    protected Algorithm() {}
    protected Algorithm(String p0, String p1){}
    public String getName(){ return null; }
    public String getSigningKeyId(){ return null; }
    public String toString(){ return null; }
    public abstract byte[] sign(byte[] p0);
    public abstract void verify(DecodedJWT p0);
    public byte[] sign(byte[] p0, byte[] p1){ return null; }
    public static Algorithm ECDSA256(ECDSAKeyProvider p0){ return null; }
    public static Algorithm ECDSA256(ECKey p0){ return null; }
    public static Algorithm ECDSA256(ECPublicKey p0, ECPrivateKey p1){ return null; }
    public static Algorithm ECDSA384(ECDSAKeyProvider p0){ return null; }
    public static Algorithm ECDSA384(ECKey p0){ return null; }
    public static Algorithm ECDSA384(ECPublicKey p0, ECPrivateKey p1){ return null; }
    public static Algorithm ECDSA512(ECDSAKeyProvider p0){ return null; }
    public static Algorithm ECDSA512(ECKey p0){ return null; }
    public static Algorithm ECDSA512(ECPublicKey p0, ECPrivateKey p1){ return null; }
    public static Algorithm HMAC256(String p0){ return null; }
    public static Algorithm HMAC256(byte[] p0){ return null; }
    public static Algorithm HMAC384(String p0){ return null; }
    public static Algorithm HMAC384(byte[] p0){ return null; }
    public static Algorithm HMAC512(String p0){ return null; }
    public static Algorithm HMAC512(byte[] p0){ return null; }
    public static Algorithm RSA256(RSAKey p0){ return null; }
    public static Algorithm RSA256(RSAKeyProvider p0){ return null; }
    public static Algorithm RSA256(RSAPublicKey p0, RSAPrivateKey p1){ return null; }
    public static Algorithm RSA384(RSAKey p0){ return null; }
    public static Algorithm RSA384(RSAKeyProvider p0){ return null; }
    public static Algorithm RSA384(RSAPublicKey p0, RSAPrivateKey p1){ return null; }
    public static Algorithm RSA512(RSAKey p0){ return null; }
    public static Algorithm RSA512(RSAKeyProvider p0){ return null; }
    public static Algorithm RSA512(RSAPublicKey p0, RSAPrivateKey p1){ return null; }
    public static Algorithm none(){ return null; }
}
