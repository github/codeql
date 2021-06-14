public boolean check(byte[] expected, byte[] data, SecretKey key) throws Exception {
    Mac mac = Mac.getInstance("HmacSHA256");
    mac.init(new SecretKeySpec(key.getEncoded(), "HmacSHA256"));
    byte[] actual = mac.doFinal(data);
    return MessageDigest.isEqual(expected, actual);
}