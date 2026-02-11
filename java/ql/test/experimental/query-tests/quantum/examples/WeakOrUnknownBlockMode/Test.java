import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

public class Test {
    public static void main(String[] args) throws Exception {
        SecretKey key = KeyGenerator.getInstance("AES").generateKey();
        IvParameterSpec iv = new IvParameterSpec(new byte[16]);
        byte[] data = "SensitiveData".getBytes();

        // Insecure block mode: ECB
        Cipher cipherECB = Cipher.getInstance("AES/ECB/PKCS5Padding"); // $Alert
        cipherECB.init(Cipher.ENCRYPT_MODE, key);
        byte[] ecbEncrypted = cipherECB.doFinal(data);
        System.out.println("ECB encrypted: " + bytesToHex(ecbEncrypted));

        // Insecure block mode: CFB
        Cipher cipherCFB = Cipher.getInstance("AES/CFB/PKCS5Padding"); // $Alert
        cipherCFB.init(Cipher.ENCRYPT_MODE, key, iv);
        byte[] cfbEncrypted = cipherCFB.doFinal(data);
        System.out.println("CFB encrypted: " + bytesToHex(cfbEncrypted));

        // Insecure block mode: OFB
        Cipher cipherOFB = Cipher.getInstance("AES/OFB/PKCS5Padding"); // $Alert
        cipherOFB.init(Cipher.ENCRYPT_MODE, key, iv);
        byte[] ofbEncrypted = cipherOFB.doFinal(data);
        System.out.println("OFB encrypted: " + bytesToHex(ofbEncrypted));

        // Insecure block mode: CTR
        Cipher cipherCTR = Cipher.getInstance("AES/CTR/NoPadding"); // $Alert
        cipherCTR.init(Cipher.ENCRYPT_MODE, key, iv);
        byte[] ctrEncrypted = cipherCTR.doFinal(data);
        System.out.println("CTR encrypted: " + bytesToHex(ctrEncrypted));

        // Secure block mode: CBC with random IV
        IvParameterSpec randomIv = new IvParameterSpec(KeyGenerator.getInstance("AES").generateKey().getEncoded());
        Cipher cipherCBCRandomIV = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipherCBCRandomIV.init(Cipher.ENCRYPT_MODE, key, randomIv);
        byte[] cbcRandomIVEncrypted = cipherCBCRandomIV.doFinal(data);
        System.out.println("CBC (random IV) encrypted: " + bytesToHex(cbcRandomIVEncrypted));

        // Secure block mode: GCM (authenticated encryption)
        IvParameterSpec gcmIv = new IvParameterSpec(new byte[12]);
        Cipher cipherGCM = Cipher.getInstance("AES/GCM/NoPadding");
        cipherGCM.init(Cipher.ENCRYPT_MODE, key, gcmIv);
        byte[] gcmEncrypted = cipherGCM.doFinal(data);
        System.out.println("GCM encrypted: " + bytesToHex(gcmEncrypted));
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes)
            sb.append(String.format("%02x", b));
        return sb.toString();
    }
}