using System;
using System.IO;
using System.Security.Cryptography;

namespace InsufficientKeySize
{
    class MainCrypto
    {

        static public byte[] EncryptWithRSA(byte[] plaintext, RSAParameters key)
        {
            try
            {
                RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(1024); // BAD
                rsa.ImportParameters(key);
                return rsa.Encrypt(plaintext, true);
            }
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }

        static public byte[] EncryptWithRSA2(byte[] plaintext, RSAParameters key)
        {
            try
            {
                RSACryptoServiceProvider rsa = new RSACryptoServiceProvider(); // BAD
                rsa = new RSACryptoServiceProvider(2048); // GOOD
                rsa.ImportParameters(key);
                return rsa.Encrypt(plaintext, true);
            }
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }

        static public byte[] EncryptWithDSA(byte[] plaintext, DSAParameters key)
        {
            try
            {
                DSACryptoServiceProvider dsa = new DSACryptoServiceProvider(2048); // GOOD
                dsa.ImportParameters(key);
                return dsa.SignData(plaintext);
            }
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }

        static public byte[] EncryptWithDSA2(byte[] plaintext, DSAParameters key)
        {
            try
            {
                DSACryptoServiceProvider dsa = new DSACryptoServiceProvider(); // BAD
                dsa = new DSACryptoServiceProvider(2048); // GOOD
                dsa.ImportParameters(key);
                return dsa.SignData(plaintext);
            }
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }

        public static void Main()
        {
            try
            {
                DSAParameters privateKeyInfo;
                DSAParameters publicKeyInfo;

                // Create a new instance of DSACryptoServiceProvider to generate
                // a new key pair.
                using (DSACryptoServiceProvider DSA = new DSACryptoServiceProvider())
                {
                    privateKeyInfo = DSA.ExportParameters(true);
                    publicKeyInfo = DSA.ExportParameters(false);
                }

                // The hash value to sign.
                byte[] HashValue =
                {
                59, 4, 248, 102, 77, 97, 142, 201,
                210, 12, 224, 93, 25, 41, 100, 197,
                213, 134, 130, 135
            };

                // The value to hold the signed value.
                byte[] SignedHashValue = DSASignHash(HashValue, privateKeyInfo, "SHA1");

                // Verify the hash and display the results.
                bool verified = DSAVerifyHash(HashValue, SignedHashValue, publicKeyInfo, "SHA1");

                if (verified)
                {
                    Console.WriteLine("The hash value was verified.");
                }
                else
                {
                    Console.WriteLine("The hash value was not verified.");
                }
            }
            catch (ArgumentNullException e)
            {
                Console.WriteLine(e.Message);
            }
        }

        public static byte[] DSASignHash(byte[] HashToSign, DSAParameters DSAKeyInfo,
            string HashAlg)
        {
            byte[] sig = null;

            try
            {
                // Create a new instance of DSACryptoServiceProvider.
                using (DSACryptoServiceProvider DSA = new DSACryptoServiceProvider(2048)) // GOOD
                {
                    // Import the key information.
                    DSA.ImportParameters(DSAKeyInfo);

                    // Create an DSASignatureFormatter object and pass it the
                    // DSACryptoServiceProvider to transfer the private key.
                    DSASignatureFormatter DSAFormatter = new DSASignatureFormatter(DSA);

                    // Set the hash algorithm to the passed value.
                    DSAFormatter.SetHashAlgorithm(HashAlg);

                    // Create a signature for HashValue and return it.
                    sig = DSAFormatter.CreateSignature(HashToSign);
                }
            }
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);
            }

            return sig;
        }

        public static bool DSAVerifyHash(byte[] HashValue, byte[] SignedHashValue,
            DSAParameters DSAKeyInfo, string HashAlg)
        {
            bool verified = false;

            try
            {
                // Create a new instance of DSACryptoServiceProvider.
                using (DSACryptoServiceProvider DSA = new DSACryptoServiceProvider())  // BAD
                {
                    // Import the key information.
                    DSA.ImportParameters(DSAKeyInfo);

                    // Create an DSASignatureDeformatter object and pass it the
                    // DSACryptoServiceProvider to transfer the private key.
                    DSASignatureDeformatter DSADeformatter = new DSASignatureDeformatter(DSA);

                    // Set the hash algorithm to the passed value.
                    DSADeformatter.SetHashAlgorithm(HashAlg);

                    // Verify signature and return the result.
                    verified = DSADeformatter.VerifySignature(HashValue, SignedHashValue);
                }
            }
            catch (CryptographicException e)
            {
                Console.WriteLine(e.Message);
            }

            return verified;
        }

        public static void Main2()
        {
            // Create a new DES key.
            DESCryptoServiceProvider key = new DESCryptoServiceProvider();  // BAD

            // Encrypt a string to a byte array.
            byte[] buffer = Encrypt("This is some plaintext!", key);

            // Decrypt the byte array back to a string.
            string plaintext = Decrypt(buffer, key);

            // Display the plaintext value to the console.
            Console.WriteLine(plaintext);
        }

        // Encrypt the string.
        public static byte[] Encrypt(string PlainText, SymmetricAlgorithm key)
        {
            // Create a memory stream.
            MemoryStream ms = new MemoryStream();

            // Create a CryptoStream using the memory stream and the
            // CSP DES key.
            CryptoStream encStream = new CryptoStream(ms, key.CreateEncryptor(), CryptoStreamMode.Write);

            // Create a StreamWriter to write a string
            // to the stream.
            StreamWriter sw = new StreamWriter(encStream);

            // Write the plaintext to the stream.
            sw.WriteLine(PlainText);

            // Close the StreamWriter and CryptoStream.
            sw.Close();
            encStream.Close();

            // Get an array of bytes that represents
            // the memory stream.
            byte[] buffer = ms.ToArray();

            // Close the memory stream.
            ms.Close();

            // Return the encrypted byte array.
            return buffer;
        }

        // Decrypt the byte array.
        public static string Decrypt(byte[] CypherText, SymmetricAlgorithm key)
        {
            // Create a memory stream to the passed buffer.
            MemoryStream ms = new MemoryStream(CypherText);

            // Create a CryptoStream using the memory stream and the
            // CSP DES key.
            CryptoStream encStream = new CryptoStream(ms, key.CreateDecryptor(), CryptoStreamMode.Read);

            // Create a StreamReader for reading the stream.
            StreamReader sr = new StreamReader(encStream);

            // Read the stream as a string.
            string val = sr.ReadLine();

            // Close the streams.
            sr.Close();
            encStream.Close();
            ms.Close();

            return val;
        }

        const int KEY_SIZE = 64;

        public static void RC2()
        {

            // Create a new instance of the RC2CryptoServiceProvider class
            // and automatically generate a Key and IV.
            RC2CryptoServiceProvider rc2CSP = new RC2CryptoServiceProvider();

            rc2CSP.EffectiveKeySize = KEY_SIZE; // BAD
            Console.WriteLine("Effective key size is {0} bits.", rc2CSP.EffectiveKeySize);

            // Get the key and IV.
            byte[] key = rc2CSP.Key;
            byte[] IV = rc2CSP.IV;

            // Get an encryptor.
            ICryptoTransform encryptor = rc2CSP.CreateEncryptor(key, IV);

            // Encrypt the data as an array of encrypted bytes in memory.
            MemoryStream msEncrypt = new MemoryStream();
            CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write);


        }

    }

}
