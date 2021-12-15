// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Cryptography
        {
            namespace KeyDerivation
            {
                // Generated from `Microsoft.AspNetCore.Cryptography.KeyDerivation.KeyDerivation` in `Microsoft.AspNetCore.Cryptography.KeyDerivation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public static class KeyDerivation
                {
                    public static System.Byte[] Pbkdf2(string password, System.Byte[] salt, Microsoft.AspNetCore.Cryptography.KeyDerivation.KeyDerivationPrf prf, int iterationCount, int numBytesRequested) => throw null;
                }

                // Generated from `Microsoft.AspNetCore.Cryptography.KeyDerivation.KeyDerivationPrf` in `Microsoft.AspNetCore.Cryptography.KeyDerivation, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public enum KeyDerivationPrf
                {
                    HMACSHA1,
                    HMACSHA256,
                    HMACSHA512,
                }

            }
        }
    }
}
