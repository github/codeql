public boolean checkHash(byte[] expectedHash, byte[] data) throws Exception {
    MessageDigest md = MessageDigest.getInstance("SHA-256");
    byte[] actualHash = md.digest(data);
    return MessageDigest.isEqual(expectedHash, actualHash);
}