using System;
using System.Security.Cryptography;

public class InsufficientKeySize
{

    public void CryptoMethod()
    {
        // BAD: Key size is less than 128
        new RC2CryptoServiceProvider().EffectiveKeySize = 64;
        // GOOD: Key size defaults to 128
        new RC2CryptoServiceProvider();
        // GOOD: Key size is greater than 128
        new RC2CryptoServiceProvider().EffectiveKeySize = 256;

        // BAD: Key size is less than 1024.
        DSACryptoServiceProvider dsaBad = new DSACryptoServiceProvider(512);
        // GOOD: Key size defaults to 1024.
        DSACryptoServiceProvider dsaGood1 = new DSACryptoServiceProvider();
        // GOOD: Key size is greater than 1024.
        DSACryptoServiceProvider dsaGood2 = new DSACryptoServiceProvider(2048);

        // BAD: Key size is less than 1024.
        RSACryptoServiceProvider rsaBad = new RSACryptoServiceProvider(512);
        // GOOD: Key size defaults to 1024.
        RSACryptoServiceProvider rsaGood1 = new RSACryptoServiceProvider();
        // GOOD: Key size is greater than 1024.
        RSACryptoServiceProvider rsaGood2 = new RSACryptoServiceProvider(2048);
    }
}

// semmle-extractor-options: /r:System.Security.Cryptography.Csp.dll
