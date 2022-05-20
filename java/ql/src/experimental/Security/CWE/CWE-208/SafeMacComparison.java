public boolean validate(HttpRequest request, SecretKey key) throws Exception {
    byte[] message = getMessageFrom(request);
    byte[] signature = getSignatureFrom(request);

    Mac mac = Mac.getInstance("HmacSHA256");
    mac.init(new SecretKeySpec(key.getEncoded(), "HmacSHA256"));
    byte[] actual = mac.doFinal(message);
    return MessageDigest.isEqual(signature, actual);
}