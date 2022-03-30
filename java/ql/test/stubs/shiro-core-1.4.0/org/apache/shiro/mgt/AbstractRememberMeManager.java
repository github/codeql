
package org.apache.shiro.mgt;
import org.apache.shiro.crypto.AesCipherService;

public abstract class AbstractRememberMeManager  {

    private byte[] encryptionCipherKey;
    private byte[] decryptionCipherKey;
    private AesCipherService cipherService;

    public AbstractRememberMeManager() {
        AesCipherService cipherService = new AesCipherService();
        this.cipherService = cipherService;
        this.setCipherKey(cipherService.generateNewKey().getEncoded());
    }

    public void setEncryptionCipherKey(byte[] encryptionCipherKey) {
        
        this.encryptionCipherKey = encryptionCipherKey;
    }


    public void setDecryptionCipherKey(byte[] decryptionCipherKey) {
        this.decryptionCipherKey = decryptionCipherKey;
    }


    public void setCipherKey(byte[] cipherKey) {
        this.setEncryptionCipherKey(cipherKey);
        this.setDecryptionCipherKey(cipherKey);
    }

   
}
