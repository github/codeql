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

    public static byte[] GenerateSalt()
    {
        using (var rng = new RNGCryptoServiceProvider())
        {
            var randomNumber = new byte[SaltSize];
            rng.GetBytes(randomNumber);
            return randomNumber;
        }
    }
}
