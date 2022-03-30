using System;
using System.Security.Cryptography;
using System.Text;

internal static class Sha1Utils
{
    public static byte[] Hash(string str)
    {
        var bytes = str == null ? new byte[0] : Encoding.UTF8.GetBytes(str);

        return Hash(bytes);
    }

    public static byte[] Hash(byte[] bytes)
    {
        var sha1 = SHA1.Create();
        var hashBytes = sha1.ComputeHash(bytes);

        return hashBytes;
    }

    public static string HexStringFromBytes(byte[] bytes)
    {
        var sb = new StringBuilder();
        foreach (var b in bytes)
        {
            var hex = b.ToString("x2");
            sb.Append(hex);
        }
        return sb.ToString();
    }

    public static byte[] Hash(byte[] salt, byte[] str)
    {
        var salted = new byte[salt.Length + str.Length];
        Array.Copy(salt, salted, salt.Length);
        Array.Copy(str, 0, salted, salt.Length, str.Length);

        return Hash(salted);
    }

    public static byte[] Xor(byte[] array1, byte[] array2)
    {
        var result = new byte[array1.Length];

        for (int i = 0; i < array1.Length; i++)
        {
            result[i] = (byte)(array1[i] ^ array2[i]);
        }

        return result;
    }
}
