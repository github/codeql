// semmle-extractor-options: /r:System.IO.FileSystem.dll /r:System.Security.Cryptography.Primitives.dll /r:System.Security.Cryptography.Csp.dll /r:System.Security.Cryptography.Algorithms.dll
using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;

namespace HardcodedSymmetricEncryptionKey
{
    class Program
    {
        static void Main(string[] args)
        {
            var a = new AesCryptoServiceProvider();

            // BAD: explicit key assignment, hard-coded value
            a.Key = new byte[] { 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 };

            var b = new AesCryptoServiceProvider()
            {
                // BAD: explicit key assignment, hard-coded value
                Key = new byte[] { 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 }
            };

            var c = new byte[] { 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 };
            var d = c;

            var byteArrayFromString = Encoding.UTF8.GetBytes("Hello, world: here is a very bad way to create a key");

            // BAD: key assignment via variable, from hard-coded value
            a.Key = d;

            // GOOD (not really, but better than hard coding)
            a.Key = File.ReadAllBytes("secret.key");

            var cp = CreateProvider(d);

            var iv = new byte[] { 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 };

            // BAD: hard-coded key passed to Encrypt [NOT DETECTED]
            var ct = Encrypt("Test string here", c, iv);

            // BAD: hard-coded key converted from string and passed to Encrypt [NOT DETECTED]
            var ct1 = Encrypt("Test string here", byteArrayFromString, iv);

            // GOOD (this function hashes password)
            var de = DecryptWithPassword(ct, c, iv);

            // BAD [NOT DETECTED]
            CreateCryptographicKey(null, byteArrayFromString);

            // GOOD
            CreateCryptographicKey(null, File.ReadAllBytes("secret.key"));
        }

        public static string DecryptWithPassword(byte[] cipherText, byte[] password, byte[] IV)
        {
            byte[] rawPlaintext;
            var salt = new byte[] { 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 };
            using (Rfc2898DeriveBytes k1 = new Rfc2898DeriveBytes(password, salt, 100))
            {
                using (Aes aes = new AesManaged())
                {
                    using (MemoryStream ms = new MemoryStream())
                    {
                        // GOOD: for this test, the flow through Rfc2898DeriveBytes should be considered GOOD.
                        // GOOD: Use of hard-coded password for Rfc2898DeriveBytes is found by Semmle CWE-798: HardcodedCredentials.ql
                        using (CryptoStream cs = new CryptoStream(ms, aes.CreateDecryptor(k1.GetBytes(16), IV), CryptoStreamMode.Write))
                        {
                            cs.Write(cipherText, 0, cipherText.Length);
                        }
                        rawPlaintext = ms.ToArray();
                    }

                    return Encoding.Unicode.GetString(rawPlaintext);
                }
            }
        }

        static SymmetricAlgorithm CreateProvider(byte[] key)
        {
            return new AesManaged()
            {
                // BAD: assignment from parameter
                Key = key
            };
        }

        public static byte[] Encrypt(string plaintext, byte[] key, byte[] IV)
        {
            byte[] rawPlaintext = Encoding.Unicode.GetBytes("Test string here");
            byte[] cipherText = null;
            using (Aes aes = new AesManaged())
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    // BAD: flow of hardcoded key to CreateEncryptor constructor
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateEncryptor(key, IV), CryptoStreamMode.Write))
                    {
                        cs.Write(rawPlaintext, 0, rawPlaintext.Length);
                    }

                    cipherText = ms.ToArray();
                }

                return cipherText;
            }
        }

        static CryptographicKey CreateCryptographicKey(SymmetricKeyAlgorithmProvider p, byte[] bytes)
        {
            var buffer = CryptographicBuffer.CreateFromByteArray(bytes);
            return p.CreateSymmetricKey(buffer);
        }
    }
}
