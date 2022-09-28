// BAD: No padding scheme is used
Cipher rsa = Cipher.getInstance("RSA/ECB/NoPadding");
...

//GOOD: OAEP padding is used
Cipher rsa = Cipher.getInstance("RSA/ECB/OAEPWithSHA-1AndMGF1Padding");
...