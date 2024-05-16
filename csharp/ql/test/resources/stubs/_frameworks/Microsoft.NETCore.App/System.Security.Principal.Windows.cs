// This file contains auto-generated code.
// Generated from `System.Security.Principal.Windows, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace Microsoft
{
    namespace Win32
    {
        namespace SafeHandles
        {
            public sealed class SafeAccessTokenHandle : System.Runtime.InteropServices.SafeHandle
            {
                public SafeAccessTokenHandle() : base(default(nint), default(bool)) => throw null;
                public SafeAccessTokenHandle(nint handle) : base(default(nint), default(bool)) => throw null;
                public static Microsoft.Win32.SafeHandles.SafeAccessTokenHandle InvalidHandle { get => throw null; }
                public override bool IsInvalid { get => throw null; }
                protected override bool ReleaseHandle() => throw null;
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
            public sealed class IdentityNotMappedException : System.SystemException
            {
                public IdentityNotMappedException() => throw null;
                public IdentityNotMappedException(string message) => throw null;
                public IdentityNotMappedException(string message, System.Exception inner) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo serializationInfo, System.Runtime.Serialization.StreamingContext streamingContext) => throw null;
                public System.Security.Principal.IdentityReferenceCollection UnmappedIdentities { get => throw null; }
            }
            public abstract class IdentityReference
            {
                public abstract override bool Equals(object o);
                public abstract override int GetHashCode();
                public abstract bool IsValidTargetType(System.Type targetType);
                public static bool operator ==(System.Security.Principal.IdentityReference left, System.Security.Principal.IdentityReference right) => throw null;
                public static bool operator !=(System.Security.Principal.IdentityReference left, System.Security.Principal.IdentityReference right) => throw null;
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
                public IdentityReferenceCollection() => throw null;
                public IdentityReferenceCollection(int capacity) => throw null;
                public System.Collections.Generic.IEnumerator<System.Security.Principal.IdentityReference> GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.Generic.ICollection<System.Security.Principal.IdentityReference>.IsReadOnly { get => throw null; }
                public bool Remove(System.Security.Principal.IdentityReference identity) => throw null;
                public System.Security.Principal.IdentityReference this[int index] { get => throw null; set { } }
                public System.Security.Principal.IdentityReferenceCollection Translate(System.Type targetType) => throw null;
                public System.Security.Principal.IdentityReferenceCollection Translate(System.Type targetType, bool forceSuccess) => throw null;
            }
            public sealed class NTAccount : System.Security.Principal.IdentityReference
            {
                public NTAccount(string name) => throw null;
                public NTAccount(string domainName, string accountName) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override bool IsValidTargetType(System.Type targetType) => throw null;
                public static bool operator ==(System.Security.Principal.NTAccount left, System.Security.Principal.NTAccount right) => throw null;
                public static bool operator !=(System.Security.Principal.NTAccount left, System.Security.Principal.NTAccount right) => throw null;
                public override string ToString() => throw null;
                public override System.Security.Principal.IdentityReference Translate(System.Type targetType) => throw null;
                public override string Value { get => throw null; }
            }
            public sealed class SecurityIdentifier : System.Security.Principal.IdentityReference, System.IComparable<System.Security.Principal.SecurityIdentifier>
            {
                public System.Security.Principal.SecurityIdentifier AccountDomainSid { get => throw null; }
                public int BinaryLength { get => throw null; }
                public int CompareTo(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public SecurityIdentifier(byte[] binaryForm, int offset) => throw null;
                public SecurityIdentifier(nint binaryForm) => throw null;
                public SecurityIdentifier(System.Security.Principal.WellKnownSidType sidType, System.Security.Principal.SecurityIdentifier domainSid) => throw null;
                public SecurityIdentifier(string sddlForm) => throw null;
                public override bool Equals(object o) => throw null;
                public bool Equals(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public override int GetHashCode() => throw null;
                public bool IsAccountSid() => throw null;
                public bool IsEqualDomainSid(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override bool IsValidTargetType(System.Type targetType) => throw null;
                public bool IsWellKnown(System.Security.Principal.WellKnownSidType type) => throw null;
                public static readonly int MaxBinaryLength;
                public static readonly int MinBinaryLength;
                public static bool operator ==(System.Security.Principal.SecurityIdentifier left, System.Security.Principal.SecurityIdentifier right) => throw null;
                public static bool operator !=(System.Security.Principal.SecurityIdentifier left, System.Security.Principal.SecurityIdentifier right) => throw null;
                public override string ToString() => throw null;
                public override System.Security.Principal.IdentityReference Translate(System.Type targetType) => throw null;
                public override string Value { get => throw null; }
            }
            [System.Flags]
            public enum TokenAccessLevels
            {
                AssignPrimary = 1,
                Duplicate = 2,
                Impersonate = 4,
                Query = 8,
                QuerySource = 16,
                AdjustPrivileges = 32,
                AdjustGroups = 64,
                AdjustDefault = 128,
                AdjustSessionId = 256,
                Read = 131080,
                Write = 131296,
                AllAccess = 983551,
                MaximumAllowed = 33554432,
            }
            public enum WellKnownSidType
            {
                NullSid = 0,
                WorldSid = 1,
                LocalSid = 2,
                CreatorOwnerSid = 3,
                CreatorGroupSid = 4,
                CreatorOwnerServerSid = 5,
                CreatorGroupServerSid = 6,
                NTAuthoritySid = 7,
                DialupSid = 8,
                NetworkSid = 9,
                BatchSid = 10,
                InteractiveSid = 11,
                ServiceSid = 12,
                AnonymousSid = 13,
                ProxySid = 14,
                EnterpriseControllersSid = 15,
                SelfSid = 16,
                AuthenticatedUserSid = 17,
                RestrictedCodeSid = 18,
                TerminalServerSid = 19,
                RemoteLogonIdSid = 20,
                LogonIdsSid = 21,
                LocalSystemSid = 22,
                LocalServiceSid = 23,
                NetworkServiceSid = 24,
                BuiltinDomainSid = 25,
                BuiltinAdministratorsSid = 26,
                BuiltinUsersSid = 27,
                BuiltinGuestsSid = 28,
                BuiltinPowerUsersSid = 29,
                BuiltinAccountOperatorsSid = 30,
                BuiltinSystemOperatorsSid = 31,
                BuiltinPrintOperatorsSid = 32,
                BuiltinBackupOperatorsSid = 33,
                BuiltinReplicatorSid = 34,
                BuiltinPreWindows2000CompatibleAccessSid = 35,
                BuiltinRemoteDesktopUsersSid = 36,
                BuiltinNetworkConfigurationOperatorsSid = 37,
                AccountAdministratorSid = 38,
                AccountGuestSid = 39,
                AccountKrbtgtSid = 40,
                AccountDomainAdminsSid = 41,
                AccountDomainUsersSid = 42,
                AccountDomainGuestsSid = 43,
                AccountComputersSid = 44,
                AccountControllersSid = 45,
                AccountCertAdminsSid = 46,
                AccountSchemaAdminsSid = 47,
                AccountEnterpriseAdminsSid = 48,
                AccountPolicyAdminsSid = 49,
                AccountRasAndIasServersSid = 50,
                NtlmAuthenticationSid = 51,
                DigestAuthenticationSid = 52,
                SChannelAuthenticationSid = 53,
                ThisOrganizationSid = 54,
                OtherOrganizationSid = 55,
                BuiltinIncomingForestTrustBuildersSid = 56,
                BuiltinPerformanceMonitoringUsersSid = 57,
                BuiltinPerformanceLoggingUsersSid = 58,
                BuiltinAuthorizationAccessSid = 59,
                MaxDefined = 60,
                WinBuiltinTerminalServerLicenseServersSid = 60,
                WinBuiltinDCOMUsersSid = 61,
                WinBuiltinIUsersSid = 62,
                WinIUserSid = 63,
                WinBuiltinCryptoOperatorsSid = 64,
                WinUntrustedLabelSid = 65,
                WinLowLabelSid = 66,
                WinMediumLabelSid = 67,
                WinHighLabelSid = 68,
                WinSystemLabelSid = 69,
                WinWriteRestrictedCodeSid = 70,
                WinCreatorOwnerRightsSid = 71,
                WinCacheablePrincipalsGroupSid = 72,
                WinNonCacheablePrincipalsGroupSid = 73,
                WinEnterpriseReadonlyControllersSid = 74,
                WinAccountReadonlyControllersSid = 75,
                WinBuiltinEventLogReadersGroup = 76,
                WinNewEnterpriseReadonlyControllersSid = 77,
                WinBuiltinCertSvcDComAccessGroup = 78,
                WinMediumPlusLabelSid = 79,
                WinLocalLogonSid = 80,
                WinConsoleLogonSid = 81,
                WinThisOrganizationCertificateSid = 82,
                WinApplicationPackageAuthoritySid = 83,
                WinBuiltinAnyPackageSid = 84,
                WinCapabilityInternetClientSid = 85,
                WinCapabilityInternetClientServerSid = 86,
                WinCapabilityPrivateNetworkClientServerSid = 87,
                WinCapabilityPicturesLibrarySid = 88,
                WinCapabilityVideosLibrarySid = 89,
                WinCapabilityMusicLibrarySid = 90,
                WinCapabilityDocumentsLibrarySid = 91,
                WinCapabilitySharedUserCertificatesSid = 92,
                WinCapabilityEnterpriseAuthenticationSid = 93,
                WinCapabilityRemovableStorageSid = 94,
            }
            public enum WindowsAccountType
            {
                Normal = 0,
                Guest = 1,
                System = 2,
                Anonymous = 3,
            }
            public enum WindowsBuiltInRole
            {
                Administrator = 544,
                User = 545,
                Guest = 546,
                PowerUser = 547,
                AccountOperator = 548,
                SystemOperator = 549,
                PrintOperator = 550,
                BackupOperator = 551,
                Replicator = 552,
            }
            public class WindowsIdentity : System.Security.Claims.ClaimsIdentity, System.Runtime.Serialization.IDeserializationCallback, System.IDisposable, System.Runtime.Serialization.ISerializable
            {
                public Microsoft.Win32.SafeHandles.SafeAccessTokenHandle AccessToken { get => throw null; }
                public override sealed string AuthenticationType { get => throw null; }
                public override System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public override System.Security.Claims.ClaimsIdentity Clone() => throw null;
                public WindowsIdentity(nint userToken) => throw null;
                public WindowsIdentity(nint userToken, string type) => throw null;
                public WindowsIdentity(nint userToken, string type, System.Security.Principal.WindowsAccountType acctType) => throw null;
                public WindowsIdentity(nint userToken, string type, System.Security.Principal.WindowsAccountType acctType, bool isAuthenticated) => throw null;
                public WindowsIdentity(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                protected WindowsIdentity(System.Security.Principal.WindowsIdentity identity) => throw null;
                public WindowsIdentity(string sUserPrincipalName) => throw null;
                public const string DefaultIssuer = default;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> DeviceClaims { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public static System.Security.Principal.WindowsIdentity GetAnonymous() => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent() => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent(bool ifImpersonating) => throw null;
                public static System.Security.Principal.WindowsIdentity GetCurrent(System.Security.Principal.TokenAccessLevels desiredAccess) => throw null;
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
                public virtual nint Token { get => throw null; }
                public System.Security.Principal.SecurityIdentifier User { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> UserClaims { get => throw null; }
            }
            public class WindowsPrincipal : System.Security.Claims.ClaimsPrincipal
            {
                public WindowsPrincipal(System.Security.Principal.WindowsIdentity ntIdentity) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> DeviceClaims { get => throw null; }
                public override System.Security.Principal.IIdentity Identity { get => throw null; }
                public virtual bool IsInRole(int rid) => throw null;
                public virtual bool IsInRole(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public virtual bool IsInRole(System.Security.Principal.WindowsBuiltInRole role) => throw null;
                public override bool IsInRole(string role) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> UserClaims { get => throw null; }
            }
        }
    }
}
