using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

namespace QuantumExamples.Cryptography
{
    public class HashExample
    {
        public static void RunExample()
        {
            const string originalMessage = "This is a message to hash!";

            // Demonstrate various hash algorithms
            DemonstrateBasicHashing(originalMessage);
            DemonstrateStreamHashing(originalMessage);
            DemonstrateOneShotHashing(originalMessage);
        }

        private static void DemonstrateBasicHashing(string message)
        {
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);

            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] hash = sha256.ComputeHash(messageBytes);
                Console.WriteLine("SHA256 hash: {0}", Convert.ToBase64String(hash));
            }

            using (SHA1 sha1 = SHA1.Create())
            {
                byte[] hash = sha1.ComputeHash(messageBytes);
                Console.WriteLine("SHA1 hash: {0}", Convert.ToBase64String(hash));
            }

            using (MD5 md5 = MD5.Create())
            {
                byte[] hash = md5.ComputeHash(messageBytes);
                Console.WriteLine("MD5 hash: {0}", Convert.ToBase64String(hash));
            }
        }

        private static void DemonstrateStreamHashing(string message)
        {
            using SHA256 sha256 = SHA256.Create();
            using MemoryStream stream = new MemoryStream();
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);
            stream.Write(messageBytes, 0, messageBytes.Length);
            stream.Position = 0;

            byte[] hash = sha256.ComputeHash(stream);
            Console.WriteLine("Stream-based SHA256 hash: {0}", Convert.ToBase64String(hash));
        }

        private static void DemonstrateOneShotHashing(string message)
        {
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);

            byte[] sha256Hash = SHA256.HashData(messageBytes);
            Console.WriteLine("One-shot SHA256 hash: {0}", Convert.ToBase64String(sha256Hash));

            byte[] sha1Hash = SHA1.HashData(messageBytes);
            Console.WriteLine("One-shot SHA1 hash: {0}", Convert.ToBase64String(sha1Hash));

            byte[] md5Hash = MD5.HashData(messageBytes);
            Console.WriteLine("One-shot MD5 hash: {0}", Convert.ToBase64String(md5Hash));
        }
    }
}