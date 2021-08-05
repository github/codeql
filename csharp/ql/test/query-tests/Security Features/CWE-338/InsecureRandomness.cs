using System;
using System.Collections.Generic;
using System.Text;
using System.Security.Cryptography;

public class InsecureRandomness
{

    public void RandomTest()
    {
        // BAD: Using insecure RNG to generate password
        string password = InsecureRandomString(10);
        password = InsecureRandomStringFromSelection(10);
        password = InsecureRandomStringFromIndexer(10);
        // IGNORE - do not track further than the first assignment to a tainted variable
        string passwd = password;
        // GOOD: Use cryptographically secure RNG
        password = SecureRandomString(10);
    }

    public static string InsecureRandomString(int length)
    {
        StringBuilder result = new StringBuilder(length);
        Random r = new Random();
        byte[] data = new byte[1];
        while (result.Length < length)
        {
            data[0] = (byte)r.Next(97, 122);
            result.Append(new ASCIIEncoding().GetString(data));
        }
        return result.ToString();
    }

    public static string SecureRandomString(int length)
    {
        StringBuilder result = new StringBuilder(length);
        using (RNGCryptoServiceProvider crypto = new RNGCryptoServiceProvider())
        {
            byte[] data = new byte[1];
            while (result.Length < length)
            {
                crypto.GetBytes(data);
                // If byte is between 97 and 122, it can be interpreted as an ASCII a-z char.
                if (data[0] >= 97 && data[0] <= 122)
                {
                    result.Append(new ASCIIEncoding().GetString(data));
                }
            }
        }
        return result.ToString();
    }

    public static string InsecureRandomStringFromSelection(int length)
    {
        string[] letters = new string[] { "A", "B", "C" };
        String result = "";
        Random r = new Random();
        while (result.Length < length)
        {
            result += letters[r.Next(3)];
        }
        return result.ToString();
    }

    public static string InsecureRandomStringFromIndexer(int length)
    {
        List<string> letters = new List<string>() { "A", "B", "C" };
        string result = "";
        Random r = new Random();
        while (result.Length < length)
        {
            result += letters[r.Next(3)];
        }
        return result;
    }

    public static string BiasPasswordGeneration()
    {
        // BAD: Membership.GeneratePassword generates a password with a bias
        string password =  System.Web.Security.Membership.GeneratePassword(12, 3);
        return password;
    }

}

namespace System.Web.Security
{
    public static class Membership
    {
        public static string GeneratePassword(int length, int numberOfNonAlphanumericCharacters)
        {
            return "stub";
        }

    }
}
