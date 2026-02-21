using System;
using System.Security.Cryptography;
using System.Text;

namespace QuantumExamples.Cryptography
{
    public class AesCbcExample
    {
        public static void RunExample()
        {
            const string originalMessage = "This is a secret message!";

            byte[] key = GenerateRandomKey();
            byte[] iv = GenerateRandomIV();

            byte[] encryptedData = EncryptStringWithCbc(originalMessage, key, iv);
            string decryptedMessage = DecryptStringWithCbc(encryptedData, key, iv);

            bool isSuccessful = originalMessage == decryptedMessage;
            Console.WriteLine("Decryption successful: {0}", isSuccessful);
        }

        private static byte[] EncryptStringWithCbc(string plaintext, byte[] key, byte[] iv)
        {
            if (plaintext == null)
                throw new ArgumentNullException(nameof(plaintext));
            if (key == null)
                throw new ArgumentNullException(nameof(key));
            if (iv == null)
                throw new ArgumentNullException(nameof(iv));

            try
            {
                using (Aes aes = Aes.Create())
                {
                    aes.Key = key;
                    byte[] plaintextBytes = Encoding.UTF8.GetBytes(plaintext);
                    return aes.EncryptCbc(plaintextBytes, iv, PaddingMode.PKCS7);
                }
            }
            catch (CryptographicException ex)
            {
                throw new CryptographicException("Encryption failed.", ex);
            }
        }

        private static string DecryptStringWithCbc(byte[] ciphertext, byte[] key, byte[] iv)
        {
            if (ciphertext == null)
                throw new ArgumentNullException(nameof(ciphertext));
            if (key == null)
                throw new ArgumentNullException(nameof(key));
            if (iv == null)
                throw new ArgumentNullException(nameof(iv));

            try
            {
                using (Aes aes = Aes.Create())
                {
                    aes.Key = key;
                    byte[] decryptedBytes = aes.DecryptCbc(ciphertext, iv, PaddingMode.PKCS7);
                    return Encoding.UTF8.GetString(decryptedBytes);
                }
            }
            catch (CryptographicException ex)
            {
                throw new CryptographicException("Decryption failed.", ex);
            }
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
