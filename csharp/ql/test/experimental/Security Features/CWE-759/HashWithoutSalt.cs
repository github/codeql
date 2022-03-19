// semmle-extractor-options: /r:System.Security.Cryptography.Primitives.dll /r:System.Security.Cryptography.Csp.dll /r:System.Security.Cryptography.Algorithms.dll

using System;
using System.Text;
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

    // BAD - Hash without a salt.
    public static string HashPassword3(string password)
    {
        HashAlgorithm hashAlg = new SHA256CryptoServiceProvider();
        byte[] passBytes = System.Text.Encoding.ASCII.GetBytes(password);
        byte[] hashBytes = hashAlg.ComputeHash(passBytes);
        return Convert.ToBase64String(hashBytes);
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

    private byte[] TryDecrypt(byte[] buffer, int offset, int length, byte[] password, int keyLen) {
        byte[] key = new byte[16];
        Array.Copy(SHA1.Create().ComputeHash(password, 0, password.Length), 0, key, 0, keyLen);
        byte[] ret = Aes.Create().CreateDecryptor(key, null).TransformFinalBlock(buffer, offset, length);
        return ret;
    }

    // GOOD - Use password hash without a salt having further processing.
    public byte[] encrypt(byte[] pass, byte[] salt, byte[] blob) {
        byte[] key = new byte[salt.Length + pass.Length];
        Array.Copy(salt, 0, key, 0, salt.Length);
        Array.Copy(pass, 0, key, salt.Length, pass.Length);
        byte[] pkb = TryDecrypt(blob, 8, blob.Length - 8, key, 16);
        return pkb;
    }

    public string CreatePasswordHash(string password, string saltkey)
    {
        var saltAndPassword = string.Concat(password, saltkey);
        HashAlgorithm algorithm = SHA256.Create();
        var hashByteArray = algorithm.ComputeHash(Encoding.UTF8.GetBytes(saltAndPassword));
        return BitConverter.ToString(hashByteArray).Replace("-", "");
    }

    private string GetMD5HashBinHex (string toBeHashed)
    {
        MD5 hash = MD5.Create ();
        byte[] result = hash.ComputeHash (Encoding.ASCII.GetBytes (toBeHashed));

        StringBuilder sb = new StringBuilder ();
        foreach (byte b in result)
            sb.Append (b.ToString ("x2"));
        
        return sb.ToString ();
    }

    // GOOD: Password concatenated with other information before hashing
    public string CreatePasswordHash2(string username, string realm, string password)
    {
        string A1 = String.Format ("{0}:{1}:{2}", username, realm, password);

        string HA1 = GetMD5HashBinHex (A1);
        return HA1;
    }

    private byte[] Xor(byte[] array1, byte[] array2) {
        var result = new byte[array1.Length];

        for (int i = 0; i < array1.Length; i++) {
            result[i] = (byte)(array1[i] ^ array2[i]);
        }

        return result;
    }

    // GOOD: Password hash without salt is further hashed with salt
    public byte[] GetScrable(byte[] password, byte[] decodedSalt) {
        var first20SaltBytes = new byte[20];
        Array.Copy(decodedSalt, first20SaltBytes, 20);

        var step1 = Sha1Utils.Hash(password);
        var step2 = Sha1Utils.Hash(step1);
        var step3 = Sha1Utils.Hash(first20SaltBytes, step2);
        var scrambleBytes = Xor(step1, step3);

        return scrambleBytes;
    }
}
