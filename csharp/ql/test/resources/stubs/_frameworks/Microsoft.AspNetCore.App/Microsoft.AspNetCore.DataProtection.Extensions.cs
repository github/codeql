// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace DataProtection
        {
            // Generated from `Microsoft.AspNetCore.DataProtection.DataProtectionAdvancedExtensions` in `Microsoft.AspNetCore.DataProtection.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DataProtectionAdvancedExtensions
            {
                public static string Protect(this Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector protector, string plaintext, System.TimeSpan lifetime) => throw null;
                public static string Protect(this Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector protector, string plaintext, System.DateTimeOffset expiration) => throw null;
                public static System.Byte[] Protect(this Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector protector, System.Byte[] plaintext, System.TimeSpan lifetime) => throw null;
                public static Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector ToTimeLimitedDataProtector(this Microsoft.AspNetCore.DataProtection.IDataProtector protector) => throw null;
                public static string Unprotect(this Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector protector, string protectedData, out System.DateTimeOffset expiration) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.DataProtectionProvider` in `Microsoft.AspNetCore.DataProtection.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public static class DataProtectionProvider
            {
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider Create(string applicationName, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider Create(string applicationName) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider Create(System.IO.DirectoryInfo keyDirectory, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider Create(System.IO.DirectoryInfo keyDirectory, System.Action<Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder> setupAction, System.Security.Cryptography.X509Certificates.X509Certificate2 certificate) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider Create(System.IO.DirectoryInfo keyDirectory, System.Action<Microsoft.AspNetCore.DataProtection.IDataProtectionBuilder> setupAction) => throw null;
                public static Microsoft.AspNetCore.DataProtection.IDataProtectionProvider Create(System.IO.DirectoryInfo keyDirectory) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector` in `Microsoft.AspNetCore.DataProtection.Extensions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public interface ITimeLimitedDataProtector : Microsoft.AspNetCore.DataProtection.IDataProtector, Microsoft.AspNetCore.DataProtection.IDataProtectionProvider
            {
                Microsoft.AspNetCore.DataProtection.ITimeLimitedDataProtector CreateProtector(string purpose);
                System.Byte[] Protect(System.Byte[] plaintext, System.DateTimeOffset expiration);
                System.Byte[] Unprotect(System.Byte[] protectedData, out System.DateTimeOffset expiration);
            }

        }
    }
}
