// This file contains auto-generated code.
// Generated from `Microsoft.AspNetCore.DataProtection.Abstractions, Version=8.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`.
namespace Microsoft
{
    namespace AspNetCore
    {
        namespace DataProtection
        {
            public static partial class DataProtectionCommonExtensions
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(this Microsoft.AspNetCore.DataProtection.IDataProtectionProvider provider, System.Collections.Generic.IEnumerable<string> purposes) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(this Microsoft.AspNetCore.DataProtection.IDataProtectionProvider provider, string purpose, params string[] subPurposes) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider GetDataProtectionProvider(this System.IServiceProvider services) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtector GetDataProtector(this System.IServiceProvider services, System.Collections.Generic.IEnumerable<string> purposes) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtector GetDataProtector(this System.IServiceProvider services, string purpose, params string[] subPurposes) => throw null;
                public static string Protect(this Microsoft.AspNetCore.DataProtection.IDataProtector protector, string plaintext) => throw null;
                public static string Unprotect(this Microsoft.AspNetCore.DataProtection.IDataProtector protector, string protectedData) => throw null;
            }
            public interface IDataProtectionProvider
            {
                Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(string purpose);
            }
            public interface IDataProtector : Microsoft.AspNetCore.DataProtection.IDataProtectionProvider
            {
                byte[] Protect(byte[] plaintext);
                byte[] Unprotect(byte[] protectedData);
            }
            namespace Infrastructure
            {
                public interface IApplicationDiscriminator
                {
                    string Discriminator { get; }
                }
            }
        }
    }
}
