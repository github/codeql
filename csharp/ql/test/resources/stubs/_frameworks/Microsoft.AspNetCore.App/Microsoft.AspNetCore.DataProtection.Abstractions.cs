// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace DataProtection
        {
            // Generated from `Microsoft.AspNetCore.DataProtection.DataProtectionCommonExtensions` in `Microsoft.AspNetCore.DataProtection.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DataProtectionCommonExtensions
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(this Microsoft.AspNetCore.DataProtection.IDataProtectionProvider provider, string purpose, params string[] subPurposes) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(this Microsoft.AspNetCore.DataProtection.IDataProtectionProvider provider, System.Collections.Generic.IEnumerable<string> purposes) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider GetDataProtectionProvider(this System.IServiceProvider services) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtector GetDataProtector(this System.IServiceProvider services, string purpose, params string[] subPurposes) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtector GetDataProtector(this System.IServiceProvider services, System.Collections.Generic.IEnumerable<string> purposes) => throw null;
                public static string Protect(this Microsoft.AspNetCore.DataProtection.IDataProtector protector, string plaintext) => throw null;
                public static string Unprotect(this Microsoft.AspNetCore.DataProtection.IDataProtector protector, string protectedData) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.IDataProtectionProvider` in `Microsoft.AspNetCore.DataProtection.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDataProtectionProvider
            {
                Microsoft.AspNetCore.DataProtection.IDataProtector CreateProtector(string purpose);
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.IDataProtector` in `Microsoft.AspNetCore.DataProtection.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface IDataProtector : Microsoft.AspNetCore.DataProtection.IDataProtectionProvider
            {
                System.Byte[] Protect(System.Byte[] plaintext);
                System.Byte[] Unprotect(System.Byte[] protectedData);
            }

            namespace Infrastructure
            {
                // Generated from `Microsoft.AspNetCore.DataProtection.Infrastructure.IApplicationDiscriminator` in `Microsoft.AspNetCore.DataProtection.Abstractions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
                public interface IApplicationDiscriminator
                {
                    string Discriminator { get; }
                }

            }
        }
    }
}
