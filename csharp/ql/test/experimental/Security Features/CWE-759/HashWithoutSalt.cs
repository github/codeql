// semmle-extractor-options: /r:System.Security.Cryptography.Primitives.dll /r:System.Security.Cryptography.Csp.dll /r:System.Security.Cryptography.Algorithms.dll

using System;
using System.Security.Cryptography;

using Windows.Security.Cryptography;
using Windows.Security.Cryptography.Core;
using Windows.Storage.Streams;

public class Test
{
    private const int SaltSize = 32;

    // BAD - Hash without a salt.
    public static String HashPassword(string password, string strAlgName ="SHA256")
    {
        IBuffer passBuff = CryptographicBuffer.ConvertStringToBinary(password, BinaryStringEncoding.Utf8);
        HashAlgorithmProvider algProvider = HashAlgorithmProvider.OpenAlgorithm(strAlgName);
        IBuffer hashBuff = algProvider.HashData(passBuff);
        return CryptographicBuffer.EncodeToBase64String(hashBuff);
    }

    // GOOD - Hash with a salt.
    public static string HashPassword2(string password, string salt, string strAlgName ="SHA256")
    {
        // Concatenate the salt with the password.
        IBuffer passBuff = CryptographicBuffer.ConvertStringToBinary(password+salt, BinaryStringEncoding.Utf8);
        HashAlgorithmProvider algProvider = HashAlgorithmProvider.OpenAlgorithm(strAlgName);
        IBuffer hashBuff = algProvider.HashData(passBuff);
        return CryptographicBuffer.EncodeToBase64String(hashBuff);
    }

    // BAD - Hash without a salt.
    public static string HashPassword(string password)
    {
        SHA256 sha256Hash = SHA256.Create();
        byte[] passBytes = System.Text.Encoding.ASCII.GetBytes(password);
        byte[] hashBytes = sha256Hash.ComputeHash(passBytes);
        return Convert.ToBase64String(hashBytes);
    }

    // GOOD - Hash with a salt.
    public static string HashPassword2(string password)
    {
        byte[] passBytes = System.Text.Encoding.ASCII.GetBytes(password);
        byte[] saltBytes = GenerateSalt();

        // Add the salt to the hash.
        byte[] rawSalted  = new byte[passBytes.Length + saltBytes.Length]; 
        passBytes.CopyTo(rawSalted, 0);
        saltBytes.CopyTo(rawSalted, passBytes.Length);

        //Create the salted hash.         
        SHA256 sha256 = SHA256.Create();
        byte[] saltedPassBytes = sha256.ComputeHash(rawSalted);

        // Add the salt value to the salted hash.
        byte[] dbPassword  = new byte[saltedPassBytes.Length + saltBytes.Length];
        saltedPassBytes.CopyTo(dbPassword, 0);
        saltBytes.CopyTo(dbPassword, saltedPassBytes.Length);

        return Convert.ToBase64String(dbPassword);
    }

    // GOOD - Hash with a salt.
    public bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
    {
        using(var hmac = new System.Security.Cryptography.HMACSHA512(passwordSalt))
        {
            var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            for(int i = 0;i<computedHash.Length;i++)
            {
                if (computedHash[i] != passwordHash[i])
                    return false;
            }
            return true;
        }
    }

    public static byte[] GenerateSalt()
    {
        using (var rng = new RNGCryptoServiceProvider())
        {
            var randomNumber = new byte[SaltSize];
            rng.GetBytes(randomNumber);
            return randomNumber;
        }
    }

    public static byte[] Combine(byte[] first, byte[] second)
    {
        // helper to combine two byte arrays
        byte[] ret = new byte[first.Length + second.Length];
        Buffer.BlockCopy(first, 0, ret, 0, first.Length);
        Buffer.BlockCopy(second, 0, ret, first.Length, second.Length);
        return ret;
    }

    // GOOD - Hash with a salt.
    public static byte[] CalculateKeys(string password, string userid)
    {
        var utf16pass = System.Text.Encoding.UTF8.GetBytes(password);
        var utf16sid = System.Text.Encoding.UTF8.GetBytes(userid);

        var utf16sidfinal = new byte[utf16sid.Length + 2];
        utf16sid.CopyTo(utf16sidfinal, 0);
        utf16sidfinal[utf16sidfinal.Length - 2] = 0x00;

        byte[] sha1bytes_password;
        byte[] hmacbytes;

        //Calculate SHA1 from user password
        using (var sha1 = new SHA1Managed())
        {
            sha1bytes_password = sha1.ComputeHash(utf16pass);
        }
        var combined = Combine(sha1bytes_password, utf16sidfinal);
        using (var hmac = new HMACSHA1(sha1bytes_password))
        {
            hmacbytes = hmac.ComputeHash(utf16sidfinal);
        }
        return hmacbytes;
    }
}
