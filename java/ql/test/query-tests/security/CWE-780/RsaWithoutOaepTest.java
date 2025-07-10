import javax.crypto.Cipher;

class RsaWithoutOaep {
    public void test() throws Exception {
        Cipher rsaBad = Cipher.getInstance("RSA/ECB/NoPadding"); // $hasTaintFlow

        Cipher rsaGood = Cipher.getInstance("RSA/ECB/OAEPWithSHA-1AndMGF1Padding"); 
    }

    public Cipher getCipher(String spec) throws Exception {
        return Cipher.getInstance(spec); // $hasTaintFlow
    }

    public void test2() throws Exception {
        Cipher rsa = getCipher("RSA/ECB/NoPadding");
    }
}