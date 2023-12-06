using var sha512 = System.Security.Cryptography.SHA512.Create();

var data = sha512.ComputeHash(Encoding.UTF8.GetBytes(content));    // BAD