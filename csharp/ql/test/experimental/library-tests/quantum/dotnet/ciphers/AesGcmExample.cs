using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace QuantumExamples.Cryptography
{
    public class AesGcmExample
    {
        public static void RunExample()
        {
            const string originalMessage = "This is a secret message!";

            byte[] key = GenerateRandomKey();
            byte[] nonce = GenerateRandomNonce();

            var (encryptedMessage, tag) = EncryptStringWithGcm(originalMessage, key, nonce);
            string decryptedMessage = DecryptStringWithGcm(encryptedMessage, key, nonce, tag);

            bool isSuccessful = originalMessage == decryptedMessage;
            Console.WriteLine("Decryption successful: {0}", isSuccessful);
        }

        private static (byte[], byte[]) EncryptStringWithGcm(string plaintext, byte[] key, byte[] nonce)
        {
            using (var aes = new AesGcm(key, AesGcm.TagByteSizes.MaxSize))
            {
                var plaintextBytes = Encoding.UTF8.GetBytes(plaintext);
                var ciphertext = new byte[plaintextBytes.Length];
                var tag = new byte[AesGcm.TagByteSizes.MaxSize];
                aes.Encrypt(nonce, plaintextBytes, ciphertext, tag);

                return (ciphertext, tag);
            }
        }

        private static string DecryptStringWithGcm(byte[] ciphertext, byte[] key, byte[] nonce, byte[] tag)
        {
            using (var aes = new AesGcm(key, AesGcm.TagByteSizes.MaxSize))
            {
                var plaintextBytes = new byte[ciphertext.Length];
                aes.Decrypt(nonce, ciphertext, tag, plaintextBytes);

                return Encoding.UTF8.GetString(plaintextBytes);
            }
        }

        private static byte[] GenerateRandomKey()
        {
            byte[] key = new byte[32];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(key);
            }
            return key;
        }

        private static byte[] GenerateRandomNonce()
        {
            byte[] nonce = new byte[AesGcm.NonceByteSizes.MaxSize];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(nonce);
            }
            return nonce;
        }
    }
}
