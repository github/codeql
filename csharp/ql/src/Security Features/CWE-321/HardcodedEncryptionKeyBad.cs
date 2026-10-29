using System.Security.Cryptography;

var b = new AesCryptoServiceProvider()
{
    // BAD: explicit key assignment, hard-coded value
    Key = new byte[] { 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00 }
};

