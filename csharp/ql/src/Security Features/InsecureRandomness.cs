using System.Security.Cryptography;
using System.Web.Security;

string GeneratePassword()
{
    // BAD: Password is generated using a cryptographically insecure RNG
    Random gen = new Random();
    string password = "mypassword" + gen.Next();

    // GOOD: Password is generated using a cryptographically secure RNG
    using (RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider())
    {
        byte[] randomBytes = new byte[sizeof(int)];
        crypto.GetBytes(randomBytes);
        password = "mypassword" + BitConverter.ToInt32(randomBytes);
    }

    // GOOD: Password is generated using a cryptographically secure RNG
    password = Membership.GeneratePassword(12, 3);

    return password;
}
