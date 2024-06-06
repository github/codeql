// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.Cryptography.KeyDerivation, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Cryptography
        {
            namespace KeyDerivation
            {
                public static class KeyDerivation
                {
                    public static byte[] Pbkdf2(string password, byte[] salt, Microsoft.AspNetCore.Cryptography.KeyDerivation.KeyDerivationPrf prf, int iterationCount, int numBytesRequested) => throw null;
                }
                public enum KeyDerivationPrf
                {
                    HMACSHA1 = 0,
                    HMACSHA256 = 1,
                    HMACSHA512 = 2,
                }
            }
        }
    }
}
