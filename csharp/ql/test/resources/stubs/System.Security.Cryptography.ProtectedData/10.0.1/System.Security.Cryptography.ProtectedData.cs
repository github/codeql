// This file contains auto-generated code.
// Generated from `System.Security.Cryptography.ProtectedData, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Security
    {
        namespace Cryptography
        {
            public enum DataProtectionScope
            {
                CurrentUser = 0,
                LocalMachine = 1,
            }
            public static class ProtectedData
            {
                public static byte[] Protect(byte[] userData, byte[] optionalEntropy, System.Security.Cryptography.DataProtectionScope scope) => throw null;
                public static byte[] Protect(System.ReadOnlySpan<byte> userData, System.Security.Cryptography.DataProtectionScope scope, System.ReadOnlySpan<byte> optionalEntropy = default(System.ReadOnlySpan<byte>)) => throw null;
                public static int Protect(System.ReadOnlySpan<byte> userData, System.Security.Cryptography.DataProtectionScope scope, System.Span<byte> destination, System.ReadOnlySpan<byte> optionalEntropy = default(System.ReadOnlySpan<byte>)) => throw null;
                public static bool TryProtect(System.ReadOnlySpan<byte> userData, System.Security.Cryptography.DataProtectionScope scope, System.Span<byte> destination, out int bytesWritten, System.ReadOnlySpan<byte> optionalEntropy = default(System.ReadOnlySpan<byte>)) => throw null;
                public static bool TryUnprotect(System.ReadOnlySpan<byte> encryptedData, System.Security.Cryptography.DataProtectionScope scope, System.Span<byte> destination, out int bytesWritten, System.ReadOnlySpan<byte> optionalEntropy = default(System.ReadOnlySpan<byte>)) => throw null;
                public static byte[] Unprotect(byte[] encryptedData, byte[] optionalEntropy, System.Security.Cryptography.DataProtectionScope scope) => throw null;
                public static byte[] Unprotect(System.ReadOnlySpan<byte> encryptedData, System.Security.Cryptography.DataProtectionScope scope, System.ReadOnlySpan<byte> optionalEntropy = default(System.ReadOnlySpan<byte>)) => throw null;
                public static int Unprotect(System.ReadOnlySpan<byte> encryptedData, System.Security.Cryptography.DataProtectionScope scope, System.Span<byte> destination, System.ReadOnlySpan<byte> optionalEntropy = default(System.ReadOnlySpan<byte>)) => throw null;
            }
        }
    }
}
