using System;
using System.Security.Cryptography;
using System.Text;

namespace QuantumExamples.Cryptography
{
    public class SignatureExample
    {
        public static void RunExample()
        {
            const string originalMessage = "This is a message to sign!";

            // Demonstrate ECDSA signing and verification
            DemonstrateECDSAExample(originalMessage);

            // Demonstrate RSA signing and verification
            DemonstrateRSAExample(originalMessage);

            // Demonstrate RSA with formatters
            DemonstrateRSAFormatterExample(originalMessage);
        }

        private static void DemonstrateECDSAExample(string message)
        {
            Console.WriteLine("=== ECDSA Example ===");

            // Create ECDSA instance with P-256 curve
            using var ecdsa = ECDsa.Create(ECCurve.NamedCurves.nistP256);

            // Message to sign
            var messageBytes = Encoding.UTF8.GetBytes(message);

            Console.WriteLine($"Original message: {message}");

            // Sign the message
            var signature = ecdsa.SignData(messageBytes, HashAlgorithmName.SHA256);

            Console.WriteLine($"Signature: {Convert.ToBase64String(signature)}");

            // Verify the signature
            var isValid = ecdsa.VerifyData(messageBytes, signature, HashAlgorithmName.SHA256);
            Console.WriteLine($"Signature valid: {isValid}");

            // Export public key for verification by others
            var publicKey = ecdsa.ExportParameters(false);
            Console.WriteLine($"Public key X: {Convert.ToBase64String(publicKey.Q.X)}");
            Console.WriteLine($"Public key Y: {Convert.ToBase64String(publicKey.Q.Y)}");

            // Demonstrate verification with tampered data
            var tamperedMessage = Encoding.UTF8.GetBytes("Hello, ECDSA Modified!");
            var isValidTampered = ecdsa.VerifyData(tamperedMessage, signature, HashAlgorithmName.SHA256);
            Console.WriteLine($"Tampered signature valid: {isValidTampered}");

            // Test with different instance
            using var ecdsaNew = ECDsa.Create();
            byte[] newMessageBytes = Encoding.UTF8.GetBytes("Hello, ECDSA!");
            var newSignature = ecdsaNew.SignData(newMessageBytes, HashAlgorithmName.SHA256);

            // Verify the signature
            var isNewValid = ecdsaNew.VerifyData(newMessageBytes, newSignature, HashAlgorithmName.SHA256);
            Console.WriteLine($"New signature valid: {isNewValid}");

            var parameters = ecdsaNew.ExportParameters(false);

            var ecdsaFromParams = ECDsa.Create(parameters);
            var signatureFromParams = ecdsaFromParams.SignData(newMessageBytes, HashAlgorithmName.SHA256);
            var isValidFromParams = ecdsaFromParams.VerifyData(newMessageBytes, signatureFromParams, HashAlgorithmName.SHA256);
            Console.WriteLine($"Signature valid with parameters: {isValidFromParams}");
        }

        private static void DemonstrateRSAExample(string message)
        {
            Console.WriteLine("=== RSA Example ===");

            using RSA rsa = RSA.Create();
            byte[] data = Encoding.UTF8.GetBytes(message);
            byte[] sig = rsa.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            bool isValid = rsa.VerifyData(data, sig, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            Console.WriteLine($"Signature valid: {isValid}");

            // Create with parameters
            RSAParameters parameters = rsa.ExportParameters(true);
            using RSA rsaWithParams = RSA.Create(parameters);
            byte[] sigWithParams = rsaWithParams.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            bool isValidWithParams = rsaWithParams.VerifyData(data, sigWithParams, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            Console.WriteLine($"Signature valid with parameters: {isValidWithParams}");

            // Create with specific key size
            using RSA rsaWithKeySize = RSA.Create(2048);
            byte[] sigWithKeySize = rsaWithKeySize.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            bool isValidWithKeySize = rsaWithKeySize.VerifyData(data, sigWithKeySize, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
            Console.WriteLine($"Signature valid with key size: {isValidWithKeySize}");
        }

        private static void DemonstrateRSAFormatterExample(string message)
        {
            Console.WriteLine("=== RSA Formatter Example ===");

            using SHA256 alg = SHA256.Create();

            byte[] data = Encoding.UTF8.GetBytes(message);
            byte[] hash = alg.ComputeHash(data);

            RSAParameters sharedParameters;
            byte[] signedHash;

            // Generate signature
            using (RSA rsa = RSA.Create())
            {
                sharedParameters = rsa.ExportParameters(false);

                RSAPKCS1SignatureFormatter rsaFormatter = new(rsa);
                rsaFormatter.SetHashAlgorithm(nameof(SHA256));

                signedHash = rsaFormatter.CreateSignature(hash);
            }

            // Verify signature
            using (RSA rsa = RSA.Create())
            {
                rsa.ImportParameters(sharedParameters);

                RSAPKCS1SignatureDeformatter rsaDeformatter = new(rsa);
                rsaDeformatter.SetHashAlgorithm(nameof(SHA256));

                if (rsaDeformatter.VerifySignature(hash, signedHash))
                {
                    Console.WriteLine("The signature is valid.");
                }
                else
                {
                    Console.WriteLine("The signature is not valid.");
                }
            }
        }
    }
}