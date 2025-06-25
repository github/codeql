// semmle-extractor-options: /r:System.Security.Cryptography.Algorithms.dll /r:System.Security.Cryptography.Primitives.dll
using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;
namespace EncryptWithoutHash
{
    public class Class1
    {
        int Rfc2898KeygenIterations = 100;
        int AesKeySizeInBits = 128;
        byte[] Salt = new byte[] { 0x15, 0xA0, 0xC3, 0x86, 0x52, 0x03, 0xF2, 0xFB, 0xD2, 0x99, 0xEA, 0xBC, 0x3D, 0xBB, 0xC1, 0xF8 };

        byte[] hmacKey = new byte[] { 0x3A, 0x6C, 0xC8, 0x4E, 0x36, 0x1D, 0x15, 0x4A, 0x93, 0xBB, 0xD5, 0x49, 0xBB, 0x0D, 0x33, 0x15, 0xA0, 0xC3, 0x86, 0x52, 0x03, 0xF2, 0xFB, 0xD2, 0x99, 0xEA, 0xBC, 0x3D, 0xBB, 0xC1, 0xF8, 0x53,
                                      0x3A, 0x6C, 0xC8, 0x4E, 0x36, 0x1D, 0x15, 0x4A, 0x93, 0xBB, 0xD5, 0x49, 0xBB, 0x0D, 0x33, 0x15, 0xA0, 0xC3, 0x86, 0x52, 0x03, 0xF2, 0xFB, 0xD2, 0x99, 0xEA, 0xBC, 0x3D, 0xBB, 0xC1, 0xF8, 0x53};

        public byte[] Enrycpt(string plainText, string password)
        {
            byte[] rawPlaintext = Encoding.Unicode.GetBytes(plainText);
            byte[] cipherText = null;
            byte[] hmac;
            using (Aes aes = new AesManaged())
            {
                aes.Padding = PaddingMode.PKCS7;
                aes.Mode = CipherMode.CBC;
                aes.KeySize = AesKeySizeInBits;
                int KeyStrengthInBytes = aes.KeySize / 8;
                Rfc2898DeriveBytes rfc2898 = new Rfc2898DeriveBytes(password, Salt, Rfc2898KeygenIterations);
                aes.Key = rfc2898.GetBytes(KeyStrengthInBytes);
                aes.IV = rfc2898.GetBytes(KeyStrengthInBytes);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(rawPlaintext, 0, rawPlaintext.Length);
                    }

                    cipherText = ms.ToArray();
                    HMACSHA256 hmacsha256 = new HMACSHA256(hmacKey);
                    hmac = hmacsha256.ComputeHash(cipherText);
                }

                Console.WriteLine("HMACSHA256: {0}", BytesToString(hmac));
                return cipherText;
            }
        }

        public byte[] EnrycptHashExternal(string plainText, string password)
        {
            byte[] rawPlaintext = Encoding.Unicode.GetBytes(plainText);
            byte[] cipherText = null;
            byte[] hmac;
            using (Aes aes = new AesManaged())
            {
                aes.Padding = PaddingMode.PKCS7;
                aes.Mode = CipherMode.CBC;
                aes.KeySize = AesKeySizeInBits;
                int KeyStrengthInBytes = aes.KeySize / 8;
                Rfc2898DeriveBytes rfc2898 = new Rfc2898DeriveBytes(password, Salt, Rfc2898KeygenIterations);
                aes.Key = rfc2898.GetBytes(KeyStrengthInBytes);
                aes.IV = rfc2898.GetBytes(KeyStrengthInBytes);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(rawPlaintext, 0, rawPlaintext.Length);
                    }

                    cipherText = ms.ToArray();
                    hmac = GetHash(cipherText);
                }

                Console.WriteLine("HMACSHA256: {0}", BytesToString(hmac));
                return cipherText;
            }
        }

        public byte[] EnrycptWithoutHash(string plainText, string password)
        {
            byte[] rawPlaintext = Encoding.Unicode.GetBytes(plainText);
            byte[] cipherText = null;
            using (Aes aes = new AesManaged())
            {
                aes.Padding = PaddingMode.PKCS7;
                aes.Mode = CipherMode.CBC;
                aes.KeySize = AesKeySizeInBits;
                int KeyStrengthInBytes = aes.KeySize / 8;
                Rfc2898DeriveBytes rfc2898 = new Rfc2898DeriveBytes(password, Salt, Rfc2898KeygenIterations);
                aes.Key = rfc2898.GetBytes(KeyStrengthInBytes);
                aes.IV = rfc2898.GetBytes(KeyStrengthInBytes);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(rawPlaintext, 0, rawPlaintext.Length);
                    }

                    cipherText = ms.ToArray();
                }

                return cipherText;
            }
        }

        public byte[] GetHash(byte[] input)
        {
            HMACSHA256 hmacsha256 = new HMACSHA256(hmacKey);
            return hmacsha256.ComputeHash(input);
        }

        public string Decrypt(byte[] cipherText, string password)
        {
            byte[] rawPlaintext;
            byte[] hmac;
            using (Aes aes = new AesManaged())
            {
                aes.Padding = PaddingMode.PKCS7;
                aes.KeySize = AesKeySizeInBits;
                int KeyStrengthInBytes = aes.KeySize / 8;
                Rfc2898DeriveBytes rfc2898 = new Rfc2898DeriveBytes(password, Salt, Rfc2898KeygenIterations);
                aes.Key = rfc2898.GetBytes(KeyStrengthInBytes);
                aes.IV = rfc2898.GetBytes(KeyStrengthInBytes);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherText, 0, cipherText.Length);
                    }

                    HMACSHA256 hmacsha256 = new HMACSHA256(hmacKey);
                    hmac = hmacsha256.ComputeHash(cipherText);

                    rawPlaintext = ms.ToArray();
                }

                Console.WriteLine("HMACSHA256: {0}", BytesToString(hmac));
                return Encoding.Unicode.GetString(rawPlaintext);
            }
        }

        public string DecryptWithoutHash(byte[] cipherText, string password)
        {
            byte[] rawPlaintext;
            using (Aes aes = new AesManaged())
            {
                aes.Padding = PaddingMode.PKCS7;
                aes.KeySize = AesKeySizeInBits;
                int KeyStrengthInBytes = aes.KeySize / 8;
                Rfc2898DeriveBytes rfc2898 = new Rfc2898DeriveBytes(password, Salt, Rfc2898KeygenIterations);
                aes.Key = rfc2898.GetBytes(KeyStrengthInBytes);
                aes.IV = rfc2898.GetBytes(KeyStrengthInBytes);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, aes.CreateDecryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(cipherText, 0, cipherText.Length);
                    }

                    rawPlaintext = ms.ToArray();
                }

                return Encoding.Unicode.GetString(rawPlaintext);
            }
        }

        public string BytesToString(byte[] byteArray)
        {
            StringBuilder str = new StringBuilder();
            foreach (byte b in byteArray)
            {
                str.Append(b.ToString("X2"));
            }

            return str.ToString();
        }
    }
}
