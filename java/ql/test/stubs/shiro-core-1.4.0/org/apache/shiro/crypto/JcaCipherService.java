//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package org.apache.shiro.crypto;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.AlgorithmParameterSpec;
import javax.crypto.Cipher;
import javax.crypto.CipherInputStream;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public abstract class JcaCipherService implements CipherService {
    private static final int DEFAULT_KEY_SIZE = 128;
    private static final int DEFAULT_STREAMING_BUFFER_SIZE = 512;
    private static final int BITS_PER_BYTE = 8;
    private static final String RANDOM_NUM_GENERATOR_ALGORITHM_NAME = "SHA1PRNG";
    private String algorithmName;
    private int keySize;
    private int streamingBufferSize;
    private boolean generateInitializationVectors;
    private int initializationVectorSize;
  

    protected JcaCipherService(String algorithmName) {
            this.algorithmName = algorithmName;
            this.keySize = 128;
            this.initializationVectorSize = 128;
            this.streamingBufferSize = 512;
            this.generateInitializationVectors = true;
    }

    public String getAlgorithmName() {
        return null;
    }

    public int getKeySize() {
       return 1;
    }

    public void setKeySize(int keySize) {
    }

    public boolean isGenerateInitializationVectors() {
        return false;
    }

    public void setGenerateInitializationVectors(boolean generateInitializationVectors) {
    }

    public int getInitializationVectorSize() {
       return 1;
    }

    public void setInitializationVectorSize(int initializationVectorSize) throws IllegalArgumentException {

    }

    protected boolean isGenerateInitializationVectors(boolean streaming) {
        return false;
    }

    public int getStreamingBufferSize() {
       return 1;
    }

    public void setStreamingBufferSize(int streamingBufferSize) {
    }

    protected String getTransformationString(boolean streaming) {
        return null;
    }

    protected byte[] generateInitializationVector(boolean streaming) {
        return null;
    }

 
 

    private byte[] crypt(byte[] bytes, byte[] key, byte[] iv, int mode) throws IllegalArgumentException, Exception {
        return null;
    }

    public void encrypt(InputStream in, OutputStream out, byte[] key) throws Exception {
    }

    private void encrypt(InputStream in, OutputStream out, byte[] key, byte[] iv, boolean prependIv) throws Exception {
    }

    public void decrypt(InputStream in, OutputStream out, byte[] key) throws Exception {
    }

    private void decrypt(InputStream in, OutputStream out, byte[] key, boolean ivPrepended) throws Exception {
    }

    private void decrypt(InputStream in, OutputStream out, byte[] decryptionKey, byte[] iv) throws Exception {

    }

    private void crypt(InputStream in, OutputStream out, byte[] keyBytes, byte[] iv, int cryptMode) throws Exception {
       
    }


}
