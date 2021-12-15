// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafeAccessTokenHandle` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeAccessTokenHandle : System.Runtime.InteropServices.SafeHandle
            {
                public static Microsoft.Win32.SafeHandles.SafeAccessTokenHandle InvalidHandle { get => throw null; }
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafeAccessTokenHandle(System.IntPtr handle) : base(default(System.IntPtr), default(bool)) => throw null;
            }

        }
    }
}
namespace System
{
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

        }
    }
    namespace Security
    {
        namespace Principal
        {
            // Generated from `System.Security.Principal.IdentityNotMappedException` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IdentityNotMappedException : System.SystemException
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public IdentityNotMappedException(string message, System.Exception inner) => throw null;
                public IdentityNotMappedException(string message) => throw null;
                public IdentityNotMappedException() => throw null;
                public System.Security.Principal.IdentityReferenceCollection UnmappedIdentities { get => throw null; }
            }

            // Generated from `System.Security.Principal.IdentityReference` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class IdentityReference
            {
                public static bool operator !=(System.Security.Principal.IdentityReference left, System.Security.Principal.IdentityReference right) => throw null;
                public static bool operator ==(System.Security.Principal.IdentityReference left, System.Security.Principal.IdentityReference right) => throw null;
                public abstract override bool Equals(object o);
                public abstract override int GetHashCode();
                internal IdentityReference() => throw null;
                public abstract bool IsValidTargetType(System.Type targetType);
                public abstract override string ToString();
                public abstract System.Security.Principal.IdentityReference Translate(System.Type targetType);
                public abstract string Value { get; }
            }

            // Generated from `System.Security.Principal.IdentityReferenceCollection` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class IdentityReferenceCollection : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<System.Security.Principal.IdentityReference>, System.Collections.Generic.ICollection<System.Security.Principal.IdentityReference>
            {
                public void Add(System.Security.Principal.IdentityReference identity) => throw null;
                public void Clear() => throw null;
                public bool Contains(System.Security.Principal.IdentityReference identity) => throw null;
                public void CopyTo(System.Security.Principal.IdentityReference[] array, int offset) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<System.Security.Principal.IdentityReference> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public IdentityReferenceCollection(int capacity) => throw null;
                public IdentityReferenceCollection() => throw null;
                bool System.Collections.Generic.ICollection<System.Security.Principal.IdentityReference>.IsReadOnly { get => throw null; }
                public System.Security.Principal.IdentityReference this[int index] { get => throw null; set => throw null; }
                public bool Remove(System.Security.Principal.IdentityReference identity) => throw null;
                public System.Security.Principal.IdentityReferenceCollection Translate(System.Type targetType, bool forceSuccess) => throw null;
                public System.Security.Principal.IdentityReferenceCollection Translate(System.Type targetType) => throw null;
            }

            // Generated from `System.Security.Principal.NTAccount` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class NTAccount : System.Security.Principal.IdentityReference
            {
                public static bool operator !=(System.Security.Principal.NTAccount left, System.Security.Principal.NTAccount right) => throw null;
                public static bool operator ==(System.Security.Principal.NTAccount left, System.Security.Principal.NTAccount right) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override bool IsValidTargetType(System.Type targetType) => throw null;
                public NTAccount(string name) => throw null;
                public NTAccount(string domainName, string accountName) => throw null;
                public override string ToString() => throw null;
                public override System.Security.Principal.IdentityReference Translate(System.Type targetType) => throw null;
                public override string Value { get => throw null; }
            }

            // Generated from `System.Security.Principal.SecurityIdentifier` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SecurityIdentifier : System.Security.Principal.IdentityReference, System.IComparable<System.Security.Principal.SecurityIdentifier>
            {
                public static bool operator !=(System.Security.Principal.SecurityIdentifier left, System.Security.Principal.SecurityIdentifier right) => throw null;
                public static bool operator ==(System.Security.Principal.SecurityIdentifier left, System.Security.Principal.SecurityIdentifier right) => throw null;
                public System.Security.Principal.SecurityIdentifier AccountDomainSid { get => throw null; }
                public int BinaryLength { get => throw null; }
                public int CompareTo(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override bool Equals(object o) => throw null;
                public bool Equals(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsAccountSid() => throw null;
                public bool IsEqualDomainSid(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override bool IsValidTargetType(System.Type targetType) => throw null;
                public bool IsWellKnown(System.Security.Principal.WellKnownSidType type) => throw null;
                public static int MaxBinaryLength;
                public static int MinBinaryLength;
                public SecurityIdentifier(string sddlForm) => throw null;
                public SecurityIdentifier(System.Security.Principal.WellKnownSidType sidType, System.Security.Principal.SecurityIdentifier domainSid) => throw null;
                public SecurityIdentifier(System.IntPtr binaryForm) => throw null;
                public SecurityIdentifier(System.Byte[] binaryForm, int offset) => throw null;
                public override string ToString() => throw null;
                public override System.Security.Principal.IdentityReference Translate(System.Type targetType) => throw null;
                public override string Value { get => throw null; }
            }

            // Generated from `System.Security.Principal.TokenAccessLevels` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum TokenAccessLevels
            {
                AdjustDefault,
                AdjustGroups,
                AdjustPrivileges,
                AdjustSessionId,
                AllAccess,
                AssignPrimary,
                Duplicate,
                Impersonate,
                MaximumAllowed,
                Query,
                QuerySource,
                Read,
                Write,
            }

            // Generated from `System.Security.Principal.WellKnownSidType` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WellKnownSidType
            {
                AccountAdministratorSid,
                AccountCertAdminsSid,
                AccountComputersSid,
                AccountControllersSid,
                AccountDomainAdminsSid,
                AccountDomainGuestsSid,
                AccountDomainUsersSid,
                AccountEnterpriseAdminsSid,
                AccountGuestSid,
                AccountKrbtgtSid,
                AccountPolicyAdminsSid,
                AccountRasAndIasServersSid,
                AccountSchemaAdminsSid,
                AnonymousSid,
                AuthenticatedUserSid,
                BatchSid,
                BuiltinAccountOperatorsSid,
                BuiltinAdministratorsSid,
                BuiltinAuthorizationAccessSid,
                BuiltinBackupOperatorsSid,
                BuiltinDomainSid,
                BuiltinGuestsSid,
                BuiltinIncomingForestTrustBuildersSid,
                BuiltinNetworkConfigurationOperatorsSid,
                BuiltinPerformanceLoggingUsersSid,
                BuiltinPerformanceMonitoringUsersSid,
                BuiltinPowerUsersSid,
                BuiltinPreWindows2000CompatibleAccessSid,
                BuiltinPrintOperatorsSid,
                BuiltinRemoteDesktopUsersSid,
                BuiltinReplicatorSid,
                BuiltinSystemOperatorsSid,
                BuiltinUsersSid,
                CreatorGroupServerSid,
                CreatorGroupSid,
                CreatorOwnerServerSid,
                CreatorOwnerSid,
                DialupSid,
                DigestAuthenticationSid,
                EnterpriseControllersSid,
                InteractiveSid,
                LocalServiceSid,
                LocalSid,
                LocalSystemSid,
                LogonIdsSid,
                MaxDefined,
                NTAuthoritySid,
                NetworkServiceSid,
                NetworkSid,
                NtlmAuthenticationSid,
                NullSid,
                OtherOrganizationSid,
                ProxySid,
                RemoteLogonIdSid,
                RestrictedCodeSid,
                SChannelAuthenticationSid,
                SelfSid,
                ServiceSid,
                TerminalServerSid,
                ThisOrganizationSid,
                WinAccountReadonlyControllersSid,
                WinApplicationPackageAuthoritySid,
                WinBuiltinAnyPackageSid,
                WinBuiltinCertSvcDComAccessGroup,
                WinBuiltinCryptoOperatorsSid,
                WinBuiltinDCOMUsersSid,
                WinBuiltinEventLogReadersGroup,
                WinBuiltinIUsersSid,
                WinBuiltinTerminalServerLicenseServersSid,
                WinCacheablePrincipalsGroupSid,
                WinCapabilityDocumentsLibrarySid,
                WinCapabilityEnterpriseAuthenticationSid,
                WinCapabilityInternetClientServerSid,
                WinCapabilityInternetClientSid,
                WinCapabilityMusicLibrarySid,
                WinCapabilityPicturesLibrarySid,
                WinCapabilityPrivateNetworkClientServerSid,
                WinCapabilityRemovableStorageSid,
                WinCapabilitySharedUserCertificatesSid,
                WinCapabilityVideosLibrarySid,
                WinConsoleLogonSid,
                WinCreatorOwnerRightsSid,
                WinEnterpriseReadonlyControllersSid,
                WinHighLabelSid,
                WinIUserSid,
                WinLocalLogonSid,
                WinLowLabelSid,
                WinMediumLabelSid,
                WinMediumPlusLabelSid,
                WinNewEnterpriseReadonlyControllersSid,
                WinNonCacheablePrincipalsGroupSid,
                WinSystemLabelSid,
                WinThisOrganizationCertificateSid,
                WinUntrustedLabelSid,
                WinWriteRestrictedCodeSid,
                WorldSid,
            }

            // Generated from `System.Security.Principal.WindowsAccountType` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WindowsAccountType
            {
                Anonymous,
                Guest,
                Normal,
                System,
            }

            // Generated from `System.Security.Principal.WindowsBuiltInRole` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum WindowsBuiltInRole
            {
                AccountOperator,
                Administrator,
                BackupOperator,
                Guest,
                PowerUser,
                PrintOperator,
                Replicator,
                SystemOperator,
                User,
            }

            // Generated from `System.Security.Principal.WindowsIdentity` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class WindowsIdentity : System.Security.Claims.ClaimsIdentity, System.Runtime.Serialization.ISerializable, System.Runtime.Serialization.IDeserializationCallback, System.IDisposable
            {
                public Microsoft.Win32.SafeHandles.SafeAccessTokenHandle AccessToken { get => throw null; }
                public override string AuthenticationType { get => throw null; }
                public override System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public override System.Security.Claims.ClaimsIdentity Clone() => throw null;
                public const string DefaultIssuer = default;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> DeviceClaims { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public static System.Security.Principal.WindowsIdentity GetAnonymous() => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent(bool ifImpersonating) => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent(System.Security.Principal.TokenAccessLevels desiredAccess) => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent() => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Security.Principal.IdentityReferenceCollection Groups { get => throw null; }
                public System.Security.Principal.TokenImpersonationLevel ImpersonationLevel { get => throw null; }
                public virtual bool IsAnonymous { get => throw null; }
                public override bool IsAuthenticated { get => throw null; }
                public virtual bool IsGuest { get => throw null; }
                public virtual bool IsSystem { get => throw null; }
                public override string Name { get => throw null; }
                void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                public System.Security.Principal.SecurityIdentifier Owner { get => throw null; }
                public static void RunImpersonated(Microsoft.Win32.SafeHandles.SafeAccessTokenHandle safeAccessTokenHandle, System.Action action) => throw null;
                public static T RunImpersonated<T>(Microsoft.Win32.SafeHandles.SafeAccessTokenHandle safeAccessTokenHandle, System.Func<T> func) => throw null;
                public static System.Threading.Tasks.Task<T> RunImpersonatedAsync<T>(Microsoft.Win32.SafeHandles.SafeAccessTokenHandle safeAccessTokenHandle, System.Func<System.Threading.Tasks.Task<T>> func) => throw null;
                public static System.Threading.Tasks.Task RunImpersonatedAsync(Microsoft.Win32.SafeHandles.SafeAccessTokenHandle safeAccessTokenHandle, System.Func<System.Threading.Tasks.Task> func) => throw null;
                public virtual System.IntPtr Token { get => throw null; }
                public System.Security.Principal.SecurityIdentifier User { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> UserClaims { get => throw null; }
                public WindowsIdentity(string sUserPrincipalName) => throw null;
                public WindowsIdentity(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public WindowsIdentity(System.IntPtr userToken, string type, System.Security.Principal.WindowsAccountType acctType, bool isAuthenticated) => throw null;
                public WindowsIdentity(System.IntPtr userToken, string type, System.Security.Principal.WindowsAccountType acctType) => throw null;
                public WindowsIdentity(System.IntPtr userToken, string type) => throw null;
                public WindowsIdentity(System.IntPtr userToken) => throw null;
                protected WindowsIdentity(System.Security.Principal.WindowsIdentity identity) => throw null;
            }

            // Generated from `System.Security.Principal.WindowsPrincipal` in `System.Security.Principal.Windows, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class WindowsPrincipal : System.Security.Claims.ClaimsPrincipal
            {
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> DeviceClaims { get => throw null; }
                public override System.Security.Principal.IIdentity Identity { get => throw null; }
                public virtual bool IsInRole(int rid) => throw null;
                public virtual bool IsInRole(System.Security.Principal.WindowsBuiltInRole role) => throw null;
                public virtual bool IsInRole(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override bool IsInRole(string role) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> UserClaims { get => throw null; }
                public WindowsPrincipal(System.Security.Principal.WindowsIdentity ntIdentity) => throw null;
            }

        }
    }
}
