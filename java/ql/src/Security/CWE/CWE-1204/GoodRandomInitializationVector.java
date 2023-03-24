byte[] iv = new byte[16];
SecureRandom random = SecureRandom.getInstanceStrong();
random.nextBytes(iv);
GCMParameterSpec params = new GCMParameterSpec(128, iv);
Cipher cipher = Cipher.getInstance("AES/GCM/PKCS5PADDING");
cipher.init(Cipher.ENCRYPT_MODE, key, params);