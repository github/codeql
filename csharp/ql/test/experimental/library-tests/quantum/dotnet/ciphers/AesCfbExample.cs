using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace QuantumExamples.Cryptography
{
    public class AesCfbExample
    {
        public static void RunExample()
        {
            const string originalMessage = "This is a secret message!";

            byte[] key = GenerateRandomKey();
            byte[] iv = GenerateRandomIV();

            byte[] encryptedData = EncryptStringWithCfb(originalMessage, key, iv);
            string decryptedMessage = DecryptStringWithCfb(encryptedData, key, iv);

            bool isSuccessful = originalMessage == decryptedMessage;
            Console.WriteLine("Decryption successful: {0}", isSuccessful);
        }

        private static byte[] EncryptStringWithCfb(string plainText, byte[] key, byte[] iv)
        {
            byte[] encrypted;

            using (Aes aes = Aes.Create())
            {
                // Set the key and IV on the AES instance.
                aes.Key = key;
                aes.IV = iv;
                aes.Mode = CipherMode.CFB;
                aes.Padding = PaddingMode.None;

                ICryptoTransform encryptor = aes.CreateEncryptor();
                byte[] plainBytes = Encoding.UTF8.GetBytes(plainText);

                // Create an empty memory stream and write the plaintext to the crypto stream.
                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        csEncrypt.Write(plainBytes, 0, plainBytes.Length);
                        csEncrypt.FlushFinalBlock();
                    }
                    encrypted = msEncrypt.ToArray();
                }
            }
            return encrypted;
        }

        private static string DecryptStringWithCfb(byte[] cipherText, byte[] key, byte[] iv)
        {
            string decrypted;

            using (Aes aes = Aes.Create())
            {
                aes.Mode = CipherMode.CFB;
                aes.Padding = PaddingMode.None;

                // Pass the key and IV to the decryptor directly.
                ICryptoTransform decryptor = aes.CreateDecryptor(key, iv);

                // Pass the ciphertext to the memory stream directly.
                using (MemoryStream msDecrypt = new MemoryStream(cipherText))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (MemoryStream msPlain = new MemoryStream())
                        {
                            csDecrypt.CopyTo(msPlain);
                            byte[] plainBytes = msPlain.ToArray();
                            decrypted = Encoding.UTF8.GetString(plainBytes);
                        }
                    }
                }
            }
            return decrypted;
        }

        private static byte[] GenerateRandomKey()
        {
            byte[] key = new byte[32]; // 256-bit key
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(key);
            }
            return key;
        }

        private static byte[] GenerateRandomIV()
        {
            byte[] iv = new byte[16]; // 128-bit IV
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(iv);
            }
            return iv;
        }
    }
}
