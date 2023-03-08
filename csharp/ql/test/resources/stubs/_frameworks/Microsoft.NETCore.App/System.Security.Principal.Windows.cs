// This file contains auto-generated code.
// Generated from `System.Security.Principal.Windows, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public class SafeAccessTokenHandle : System.Runtime.InteropServices.SafeHandle
            {
                public static Microsoft.Win32.SafeHandles.SafeAccessTokenHandle InvalidHandle { get => throw null; }
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
                public SafeAccessTokenHandle() : base(default(System.IntPtr), default(bool)) => throw null;
                public SafeAccessTokenHandle(System.IntPtr handle) : base(default(System.IntPtr), default(bool)) => throw null;
            }

        }
    }
}
namespace System
{
    namespace Security
    {
        namespace Principal
        {
            public class IdentityNotMappedException : System.SystemException
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public IdentityNotMappedException() => throw null;
                public IdentityNotMappedException(string message) => throw null;
                public IdentityNotMappedException(string message, System.Exception inner) => throw null;
                public System.Security.Principal.IdentityReferenceCollection UnmappedIdentities { get => throw null; }
            }

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

            public class IdentityReferenceCollection : System.Collections.Generic.ICollection<System.Security.Principal.IdentityReference>, System.Collections.Generic.IEnumerable<System.Security.Principal.IdentityReference>, System.Collections.IEnumerable
            {
                public void Add(System.Security.Principal.IdentityReference identity) => throw null;
                public void Clear() => throw null;
                public bool Contains(System.Security.Principal.IdentityReference identity) => throw null;
                public void CopyTo(System.Security.Principal.IdentityReference[] array, int offset) => throw null;
                public int Count { get => throw null; }
                public System.Collections.Generic.IEnumerator<System.Security.Principal.IdentityReference> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public IdentityReferenceCollection() => throw null;
                public IdentityReferenceCollection(int capacity) => throw null;
                bool System.Collections.Generic.ICollection<System.Security.Principal.IdentityReference>.IsReadOnly { get => throw null; }
                public System.Security.Principal.IdentityReference this[int index] { get => throw null; set => throw null; }
                public bool Remove(System.Security.Principal.IdentityReference identity) => throw null;
                public System.Security.Principal.IdentityReferenceCollection Translate(System.Type targetType) => throw null;
                public System.Security.Principal.IdentityReferenceCollection Translate(System.Type targetType, bool forceSuccess) => throw null;
            }

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

            public class SecurityIdentifier : System.Security.Principal.IdentityReference, System.IComparable<System.Security.Principal.SecurityIdentifier>
            {
                public static bool operator !=(System.Security.Principal.SecurityIdentifier left, System.Security.Principal.SecurityIdentifier right) => throw null;
                public static bool operator ==(System.Security.Principal.SecurityIdentifier left, System.Security.Principal.SecurityIdentifier right) => throw null;
                public System.Security.Principal.SecurityIdentifier AccountDomainSid { get => throw null; }
                public int BinaryLength { get => throw null; }
                public int CompareTo(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public bool Equals(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override bool Equals(object o) => throw null;
                public void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsAccountSid() => throw null;
                public bool IsEqualDomainSid(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override bool IsValidTargetType(System.Type targetType) => throw null;
                public bool IsWellKnown(System.Security.Principal.WellKnownSidType type) => throw null;
                public static int MaxBinaryLength;
                public static int MinBinaryLength;
                public SecurityIdentifier(System.Byte[] binaryForm, int offset) => throw null;
                public SecurityIdentifier(System.IntPtr binaryForm) => throw null;
                public SecurityIdentifier(System.Security.Principal.WellKnownSidType sidType, System.Security.Principal.SecurityIdentifier domainSid) => throw null;
                public SecurityIdentifier(string sddlForm) => throw null;
                public override string ToString() => throw null;
                public override System.Security.Principal.IdentityReference Translate(System.Type targetType) => throw null;
                public override string Value { get => throw null; }
            }

            [System.Flags]
            public enum TokenAccessLevels : int
            {
                AdjustDefault = 128,
                AdjustGroups = 64,
                AdjustPrivileges = 32,
                AdjustSessionId = 256,
                AllAccess = 983551,
                AssignPrimary = 1,
                Duplicate = 2,
                Impersonate = 4,
                MaximumAllowed = 33554432,
                Query = 8,
                QuerySource = 16,
                Read = 131080,
                Write = 131296,
            }

            public enum WellKnownSidType : int
            {
                AccountAdministratorSid = 38,
                AccountCertAdminsSid = 46,
                AccountComputersSid = 44,
                AccountControllersSid = 45,
                AccountDomainAdminsSid = 41,
                AccountDomainGuestsSid = 43,
                AccountDomainUsersSid = 42,
                AccountEnterpriseAdminsSid = 48,
                AccountGuestSid = 39,
                AccountKrbtgtSid = 40,
                AccountPolicyAdminsSid = 49,
                AccountRasAndIasServersSid = 50,
                AccountSchemaAdminsSid = 47,
                AnonymousSid = 13,
                AuthenticatedUserSid = 17,
                BatchSid = 10,
                BuiltinAccountOperatorsSid = 30,
                BuiltinAdministratorsSid = 26,
                BuiltinAuthorizationAccessSid = 59,
                BuiltinBackupOperatorsSid = 33,
                BuiltinDomainSid = 25,
                BuiltinGuestsSid = 28,
                BuiltinIncomingForestTrustBuildersSid = 56,
                BuiltinNetworkConfigurationOperatorsSid = 37,
                BuiltinPerformanceLoggingUsersSid = 58,
                BuiltinPerformanceMonitoringUsersSid = 57,
                BuiltinPowerUsersSid = 29,
                BuiltinPreWindows2000CompatibleAccessSid = 35,
                BuiltinPrintOperatorsSid = 32,
                BuiltinRemoteDesktopUsersSid = 36,
                BuiltinReplicatorSid = 34,
                BuiltinSystemOperatorsSid = 31,
                BuiltinUsersSid = 27,
                CreatorGroupServerSid = 6,
                CreatorGroupSid = 4,
                CreatorOwnerServerSid = 5,
                CreatorOwnerSid = 3,
                DialupSid = 8,
                DigestAuthenticationSid = 52,
                EnterpriseControllersSid = 15,
                InteractiveSid = 11,
                LocalServiceSid = 23,
                LocalSid = 2,
                LocalSystemSid = 22,
                LogonIdsSid = 21,
                MaxDefined = 60,
                NTAuthoritySid = 7,
                NetworkServiceSid = 24,
                NetworkSid = 9,
                NtlmAuthenticationSid = 51,
                NullSid = 0,
                OtherOrganizationSid = 55,
                ProxySid = 14,
                RemoteLogonIdSid = 20,
                RestrictedCodeSid = 18,
                SChannelAuthenticationSid = 53,
                SelfSid = 16,
                ServiceSid = 12,
                TerminalServerSid = 19,
                ThisOrganizationSid = 54,
                WinAccountReadonlyControllersSid = 75,
                WinApplicationPackageAuthoritySid = 83,
                WinBuiltinAnyPackageSid = 84,
                WinBuiltinCertSvcDComAccessGroup = 78,
                WinBuiltinCryptoOperatorsSid = 64,
                WinBuiltinDCOMUsersSid = 61,
                WinBuiltinEventLogReadersGroup = 76,
                WinBuiltinIUsersSid = 62,
                WinBuiltinTerminalServerLicenseServersSid = 60,
                WinCacheablePrincipalsGroupSid = 72,
                WinCapabilityDocumentsLibrarySid = 91,
                WinCapabilityEnterpriseAuthenticationSid = 93,
                WinCapabilityInternetClientServerSid = 86,
                WinCapabilityInternetClientSid = 85,
                WinCapabilityMusicLibrarySid = 90,
                WinCapabilityPicturesLibrarySid = 88,
                WinCapabilityPrivateNetworkClientServerSid = 87,
                WinCapabilityRemovableStorageSid = 94,
                WinCapabilitySharedUserCertificatesSid = 92,
                WinCapabilityVideosLibrarySid = 89,
                WinConsoleLogonSid = 81,
                WinCreatorOwnerRightsSid = 71,
                WinEnterpriseReadonlyControllersSid = 74,
                WinHighLabelSid = 68,
                WinIUserSid = 63,
                WinLocalLogonSid = 80,
                WinLowLabelSid = 66,
                WinMediumLabelSid = 67,
                WinMediumPlusLabelSid = 79,
                WinNewEnterpriseReadonlyControllersSid = 77,
                WinNonCacheablePrincipalsGroupSid = 73,
                WinSystemLabelSid = 69,
                WinThisOrganizationCertificateSid = 82,
                WinUntrustedLabelSid = 65,
                WinWriteRestrictedCodeSid = 70,
                WorldSid = 1,
            }

            public enum WindowsAccountType : int
            {
                Anonymous = 3,
                Guest = 1,
                Normal = 0,
                System = 2,
            }

            public enum WindowsBuiltInRole : int
            {
                AccountOperator = 548,
                Administrator = 544,
                BackupOperator = 551,
                Guest = 546,
                PowerUser = 547,
                PrintOperator = 550,
                Replicator = 552,
                SystemOperator = 549,
                User = 545,
            }

            public class WindowsIdentity : System.Security.Claims.ClaimsIdentity, System.IDisposable, System.Runtime.Serialization.IDeserializationCallback, System.Runtime.Serialization.ISerializable
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
                public static System.Security.Principal.WindowsIdentity GetCurrent() => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent(System.Security.Principal.TokenAccessLevels desiredAccess) => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent(bool ifImpersonating) => throw null;
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
                public static System.Threading.Tasks.Task RunImpersonatedAsync(Microsoft.Win32.SafeHandles.SafeAccessTokenHandle safeAccessTokenHandle, System.Func<System.Threading.Tasks.Task> func) => throw null;
                public static System.Threading.Tasks.Task<T> RunImpersonatedAsync<T>(Microsoft.Win32.SafeHandles.SafeAccessTokenHandle safeAccessTokenHandle, System.Func<System.Threading.Tasks.Task<T>> func) => throw null;
                public virtual System.IntPtr Token { get => throw null; }
                public System.Security.Principal.SecurityIdentifier User { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> UserClaims { get => throw null; }
                public WindowsIdentity(System.IntPtr userToken) => throw null;
                public WindowsIdentity(System.IntPtr userToken, string type) => throw null;
                public WindowsIdentity(System.IntPtr userToken, string type, System.Security.Principal.WindowsAccountType acctType) => throw null;
                public WindowsIdentity(System.IntPtr userToken, string type, System.Security.Principal.WindowsAccountType acctType, bool isAuthenticated) => throw null;
                public WindowsIdentity(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                protected WindowsIdentity(System.Security.Principal.WindowsIdentity identity) => throw null;
                public WindowsIdentity(string sUserPrincipalName) => throw null;
            }

            public class WindowsPrincipal : System.Security.Claims.ClaimsPrincipal
            {
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> DeviceClaims { get => throw null; }
                public override System.Security.Principal.IIdentity Identity { get => throw null; }
                public virtual bool IsInRole(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public virtual bool IsInRole(System.Security.Principal.WindowsBuiltInRole role) => throw null;
                public virtual bool IsInRole(int rid) => throw null;
                public override bool IsInRole(string role) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> UserClaims { get => throw null; }
                public WindowsPrincipal(System.Security.Principal.WindowsIdentity ntIdentity) => throw null;
            }

        }
    }
}
