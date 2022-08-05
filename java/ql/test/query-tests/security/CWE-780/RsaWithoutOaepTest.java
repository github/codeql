import javax.crypto.Cipher;

class RsaWithoutOaep {
    public void test() throws Exception {
        Cipher rsaBad = Cipher.getInstance("RSA/ECB/NoPadding"); // $hasResult

        Cipher rsaGood = Cipher.getInstance("RSA/ECB/OAEPWithSHA-1AndMGF1Padding"); 
    }
}