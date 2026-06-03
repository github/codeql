using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace QuantumExamples.Cryptography
{
    public class HMACExample
    {
        public static void RunExample()
        {
            const string originalMessage = "This is a message to authenticate!";

            // Demonstrate various MAC approaches
            DemonstrateHMACMethods(originalMessage);
            DemonstrateKeyedHashAlgorithm(originalMessage);
            DemonstrateOneShotMAC(originalMessage);
            DemonstrateStreamBasedMAC(originalMessage);
        }

        private static void DemonstrateHMACMethods(string message)
        {
            Console.WriteLine("=== HMAC Methods ===");
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);
            byte[] key = GenerateKey(32); // 256-bit key

            Console.WriteLine($"Original message: {message}");
            Console.WriteLine($"Key: {Convert.ToBase64String(key)}");

            // HMAC-SHA256 using HMACSHA256 class
            using (HMACSHA256 hmacSha256 = new HMACSHA256(key))
            {
                byte[] hash = hmacSha256.ComputeHash(messageBytes);
                Console.WriteLine($"HMAC-SHA256: {Convert.ToBase64String(hash)}");
            }

            // HMAC-SHA1 using HMACSHA1 class
            using (HMACSHA1 hmacSha1 = new HMACSHA1(key))
            {
                byte[] hash = hmacSha1.ComputeHash(messageBytes);
                Console.WriteLine($"HMAC-SHA1: {Convert.ToBase64String(hash)}");
            }

            // HMAC-SHA384 using HMACSHA384 class
            using (HMACSHA384 hmacSha384 = new HMACSHA384(key))
            {
                byte[] hash = hmacSha384.ComputeHash(messageBytes);
                Console.WriteLine($"HMAC-SHA384: {Convert.ToBase64String(hash)}");
            }

            // HMAC-SHA512 using HMACSHA512 class
            using (HMACSHA512 hmacSha512 = new HMACSHA512(key))
            {
                byte[] hash = hmacSha512.ComputeHash(messageBytes);
                Console.WriteLine($"HMAC-SHA512: {Convert.ToBase64String(hash)}");
            }
        }

        private static void DemonstrateKeyedHashAlgorithm(string message)
        {
            Console.WriteLine("\n=== KeyedHashAlgorithm Base Class ===");
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);
            byte[] key = GenerateKey(32);

            // Using KeyedHashAlgorithm base class reference
            using (KeyedHashAlgorithm keyedHash = new HMACSHA256(key))
            {
                byte[] hash = keyedHash.ComputeHash(messageBytes);
                Console.WriteLine($"KeyedHashAlgorithm (HMAC-SHA256): {Convert.ToBase64String(hash)}");
                Console.WriteLine($"Algorithm name: {keyedHash.GetType().Name}");
                Console.WriteLine($"Hash size: {keyedHash.HashSize} bits");
            }
        }

        private static void DemonstrateOneShotMAC(string message)
        {
            Console.WriteLine("\n=== One-Shot MAC Methods ===");
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);
            byte[] key = GenerateKey(32);

            byte[] hmacSha256OneShot = HMACSHA256.HashData(key, messageBytes);
            Console.WriteLine($"One-shot HMAC-SHA256: {Convert.ToBase64String(hmacSha256OneShot)}");

            byte[] hmacSha1OneShot = HMACSHA1.HashData(key, messageBytes);
            Console.WriteLine($"One-shot HMAC-SHA1: {Convert.ToBase64String(hmacSha1OneShot)}");

            byte[] hmacSha384OneShot = HMACSHA384.HashData(key, messageBytes);
            Console.WriteLine($"One-shot HMAC-SHA384: {Convert.ToBase64String(hmacSha384OneShot)}");

            byte[] hmacSha512OneShot = HMACSHA512.HashData(key, messageBytes);
            Console.WriteLine($"One-shot HMAC-SHA512: {Convert.ToBase64String(hmacSha512OneShot)}");
        }

        private static void DemonstrateStreamBasedMAC(string message)
        {
            Console.WriteLine("\n=== Stream-Based MAC ===");
            byte[] key = GenerateKey(32);

            using (HMACSHA256 hmac = new HMACSHA256(key))
            using (MemoryStream stream = new MemoryStream())
            {
                byte[] messageBytes = Encoding.UTF8.GetBytes(message);
                stream.Write(messageBytes, 0, messageBytes.Length);
                stream.Position = 0;

                byte[] hash = hmac.ComputeHash(stream);
                Console.WriteLine($"Stream-based HMAC-SHA256: {Convert.ToBase64String(hash)}");
            }
        }

        private static byte[] GenerateKey(int sizeInBytes)
        {
            byte[] key = new byte[sizeInBytes];
            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(key);
            }
            return key;
        }
    }
}