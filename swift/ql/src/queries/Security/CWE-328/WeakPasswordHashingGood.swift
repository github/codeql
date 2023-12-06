using System.Security.Cryptography;
using Konscious.Security.Cryptography;  // use NuGet package Konscious.Security.Cryptography.Argon2

// See https://github.com/kmaragon/Konscious.Security.Cryptography#konscioussecuritycryptographyargon2

public class Argon2Hasher
{
    public byte[] ComputeHash(byte[] password, byte[] salt)
    {
        // choose Argon2i, Argon2id or Argon2d as appropriate
        using var argon2 = new Argon2id(password);
        argon2.Salt = salt;

        // read the Argon2 documentation to understand these parameters, and reference:
        // https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html#argon2id
        argon2.DegreeOfParallelism = 4;  // number of threads you can spawn on your system - the higher, the better
        argon2.Iterations = 5;           // set as high as your system can manage, within time constraints
        argon2.MemorySize = 1024 * 2048; // 2GB RAM, for example - set this as high as you can, within memory limits on your system

        return argon2.GetBytes(32);                
    }

    // use a fixed-time comparison to avoid timing attacks
    public bool Equals(byte[] hash1, byte[] hash2) => CryptographicOperations.FixedTimeEquals(hash1, hash2);

    // generate a salt securely with a cryptographic random number generator
    public static byte[] GenerateSalt()
    {
        var buffer = new byte[32];
        using var rng = new RNGCryptoServiceProvider();
        rng.GetBytes(buffer);
        return buffer;
    }
}

var argon2 = new Argon2Hasher();

// Create the hash
var bytes = Encoding.UTF8.GetBytes("this is a password");    // it should not be hardcoded in reality, but this is just a demo
var salt = Argon2Hasher.GenerateSalt();                      // salt is kept with hash; it is not secret, just unique per hash
var hash = argon2.ComputeHash(bytes, salt);

// Check the hash - this will trivially always pass, but in reality you would have to retrieve the hash for the comparison
if(argon2id.Equals(argon2.ComputeHash(bytes, salt), hash))
{
    Console.WriteLine("PASS");
}
else
{
    Console.WriteLine("FAIL");
}
