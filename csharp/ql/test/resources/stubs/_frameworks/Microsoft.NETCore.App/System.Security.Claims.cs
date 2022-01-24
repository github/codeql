// This file contains auto-generated code.

namespace System
{
    namespace Security
    {
        namespace Claims
        {
            // Generated from `System.Security.Claims.Claim` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class Claim
            {
                public Claim(System.IO.BinaryReader reader) => throw null;
                public Claim(System.IO.BinaryReader reader, System.Security.Claims.ClaimsIdentity subject) => throw null;
                protected Claim(System.Security.Claims.Claim other) => throw null;
                protected Claim(System.Security.Claims.Claim other, System.Security.Claims.ClaimsIdentity subject) => throw null;
                public Claim(string type, string value) => throw null;
                public Claim(string type, string value, string valueType) => throw null;
                public Claim(string type, string value, string valueType, string issuer) => throw null;
                public Claim(string type, string value, string valueType, string issuer, string originalIssuer) => throw null;
                public Claim(string type, string value, string valueType, string issuer, string originalIssuer, System.Security.Claims.ClaimsIdentity subject) => throw null;
                public virtual System.Security.Claims.Claim Clone() => throw null;
                public virtual System.Security.Claims.Claim Clone(System.Security.Claims.ClaimsIdentity identity) => throw null;
                protected virtual System.Byte[] CustomSerializationData { get => throw null; }
                public string Issuer { get => throw null; }
                public string OriginalIssuer { get => throw null; }
                public System.Collections.Generic.IDictionary<string, string> Properties { get => throw null; }
                public System.Security.Claims.ClaimsIdentity Subject { get => throw null; }
                public override string ToString() => throw null;
                public string Type { get => throw null; }
                public string Value { get => throw null; }
                public string ValueType { get => throw null; }
                public virtual void WriteTo(System.IO.BinaryWriter writer) => throw null;
                protected virtual void WriteTo(System.IO.BinaryWriter writer, System.Byte[] userData) => throw null;
            }

            // Generated from `System.Security.Claims.ClaimTypes` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class ClaimTypes
            {
                public const string Actor = default;
                public const string Anonymous = default;
                public const string Authentication = default;
                public const string AuthenticationInstant = default;
                public const string AuthenticationMethod = default;
                public const string AuthorizationDecision = default;
                public const string CookiePath = default;
                public const string Country = default;
                public const string DateOfBirth = default;
                public const string DenyOnlyPrimaryGroupSid = default;
                public const string DenyOnlyPrimarySid = default;
                public const string DenyOnlySid = default;
                public const string DenyOnlyWindowsDeviceGroup = default;
                public const string Dns = default;
                public const string Dsa = default;
                public const string Email = default;
                public const string Expiration = default;
                public const string Expired = default;
                public const string Gender = default;
                public const string GivenName = default;
                public const string GroupSid = default;
                public const string Hash = default;
                public const string HomePhone = default;
                public const string IsPersistent = default;
                public const string Locality = default;
                public const string MobilePhone = default;
                public const string Name = default;
                public const string NameIdentifier = default;
                public const string OtherPhone = default;
                public const string PostalCode = default;
                public const string PrimaryGroupSid = default;
                public const string PrimarySid = default;
                public const string Role = default;
                public const string Rsa = default;
                public const string SerialNumber = default;
                public const string Sid = default;
                public const string Spn = default;
                public const string StateOrProvince = default;
                public const string StreetAddress = default;
                public const string Surname = default;
                public const string System = default;
                public const string Thumbprint = default;
                public const string Upn = default;
                public const string Uri = default;
                public const string UserData = default;
                public const string Version = default;
                public const string Webpage = default;
                public const string WindowsAccountName = default;
                public const string WindowsDeviceClaim = default;
                public const string WindowsDeviceGroup = default;
                public const string WindowsFqbnVersion = default;
                public const string WindowsSubAuthority = default;
                public const string WindowsUserClaim = default;
                public const string X500DistinguishedName = default;
            }

            // Generated from `System.Security.Claims.ClaimValueTypes` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class ClaimValueTypes
            {
                public const string Base64Binary = default;
                public const string Base64Octet = default;
                public const string Boolean = default;
                public const string Date = default;
                public const string DateTime = default;
                public const string DaytimeDuration = default;
                public const string DnsName = default;
                public const string Double = default;
                public const string DsaKeyValue = default;
                public const string Email = default;
                public const string Fqbn = default;
                public const string HexBinary = default;
                public const string Integer = default;
                public const string Integer32 = default;
                public const string Integer64 = default;
                public const string KeyInfo = default;
                public const string Rfc822Name = default;
                public const string Rsa = default;
                public const string RsaKeyValue = default;
                public const string Sid = default;
                public const string String = default;
                public const string Time = default;
                public const string UInteger32 = default;
                public const string UInteger64 = default;
                public const string UpnName = default;
                public const string X500Name = default;
                public const string YearMonthDuration = default;
            }

            // Generated from `System.Security.Claims.ClaimsIdentity` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ClaimsIdentity : System.Security.Principal.IIdentity
            {
                public System.Security.Claims.ClaimsIdentity Actor { get => throw null; set => throw null; }
                public virtual void AddClaim(System.Security.Claims.Claim claim) => throw null;
                public virtual void AddClaims(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                public virtual string AuthenticationType { get => throw null; }
                public object BootstrapContext { get => throw null; set => throw null; }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public ClaimsIdentity() => throw null;
                public ClaimsIdentity(System.IO.BinaryReader reader) => throw null;
                protected ClaimsIdentity(System.Security.Claims.ClaimsIdentity other) => throw null;
                public ClaimsIdentity(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                public ClaimsIdentity(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, string authenticationType) => throw null;
                public ClaimsIdentity(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, string authenticationType, string nameType, string roleType) => throw null;
                public ClaimsIdentity(System.Security.Principal.IIdentity identity) => throw null;
                public ClaimsIdentity(System.Security.Principal.IIdentity identity, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                public ClaimsIdentity(System.Security.Principal.IIdentity identity, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, string authenticationType, string nameType, string roleType) => throw null;
                protected ClaimsIdentity(System.Runtime.Serialization.SerializationInfo info) => throw null;
                protected ClaimsIdentity(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public ClaimsIdentity(string authenticationType) => throw null;
                public ClaimsIdentity(string authenticationType, string nameType, string roleType) => throw null;
                public virtual System.Security.Claims.ClaimsIdentity Clone() => throw null;
                protected virtual System.Security.Claims.Claim CreateClaim(System.IO.BinaryReader reader) => throw null;
                protected virtual System.Byte[] CustomSerializationData { get => throw null; }
                public const string DefaultIssuer = default;
                public const string DefaultNameClaimType = default;
                public const string DefaultRoleClaimType = default;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> FindAll(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> FindAll(string type) => throw null;
                public virtual System.Security.Claims.Claim FindFirst(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual System.Security.Claims.Claim FindFirst(string type) => throw null;
                protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual bool HasClaim(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual bool HasClaim(string type, string value) => throw null;
                public virtual bool IsAuthenticated { get => throw null; }
                public string Label { get => throw null; set => throw null; }
                public virtual string Name { get => throw null; }
                public string NameClaimType { get => throw null; }
                public virtual void RemoveClaim(System.Security.Claims.Claim claim) => throw null;
                public string RoleClaimType { get => throw null; }
                public virtual bool TryRemoveClaim(System.Security.Claims.Claim claim) => throw null;
                public virtual void WriteTo(System.IO.BinaryWriter writer) => throw null;
                protected virtual void WriteTo(System.IO.BinaryWriter writer, System.Byte[] userData) => throw null;
            }

            // Generated from `System.Security.Claims.ClaimsPrincipal` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class ClaimsPrincipal : System.Security.Principal.IPrincipal
            {
                public virtual void AddIdentities(System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity> identities) => throw null;
                public virtual void AddIdentity(System.Security.Claims.ClaimsIdentity identity) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public ClaimsPrincipal() => throw null;
                public ClaimsPrincipal(System.IO.BinaryReader reader) => throw null;
                public ClaimsPrincipal(System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity> identities) => throw null;
                public ClaimsPrincipal(System.Security.Principal.IIdentity identity) => throw null;
                public ClaimsPrincipal(System.Security.Principal.IPrincipal principal) => throw null;
                protected ClaimsPrincipal(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public static System.Func<System.Security.Claims.ClaimsPrincipal> ClaimsPrincipalSelector { get => throw null; set => throw null; }
                public virtual System.Security.Claims.ClaimsPrincipal Clone() => throw null;
                protected virtual System.Security.Claims.ClaimsIdentity CreateClaimsIdentity(System.IO.BinaryReader reader) => throw null;
                public static System.Security.Claims.ClaimsPrincipal Current { get => throw null; }
                protected virtual System.Byte[] CustomSerializationData { get => throw null; }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> FindAll(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> FindAll(string type) => throw null;
                public virtual System.Security.Claims.Claim FindFirst(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual System.Security.Claims.Claim FindFirst(string type) => throw null;
                protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual bool HasClaim(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual bool HasClaim(string type, string value) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity> Identities { get => throw null; }
                public virtual System.Security.Principal.IIdentity Identity { get => throw null; }
                public virtual bool IsInRole(string role) => throw null;
                public static System.Func<System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity>, System.Security.Claims.ClaimsIdentity> PrimaryIdentitySelector { get => throw null; set => throw null; }
                public virtual void WriteTo(System.IO.BinaryWriter writer) => throw null;
                protected virtual void WriteTo(System.IO.BinaryWriter writer, System.Byte[] userData) => throw null;
            }

        }
        namespace Principal
        {
            // Generated from `System.Security.Principal.GenericIdentity` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class GenericIdentity : System.Security.Claims.ClaimsIdentity
            {
                public override string AuthenticationType { get => throw null; }
                public override System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public override System.Security.Claims.ClaimsIdentity Clone() => throw null;
                protected GenericIdentity(System.Security.Principal.GenericIdentity identity) => throw null;
                public GenericIdentity(string name) => throw null;
                public GenericIdentity(string name, string type) => throw null;
                public override bool IsAuthenticated { get => throw null; }
                public override string Name { get => throw null; }
            }

            // Generated from `System.Security.Principal.GenericPrincipal` in `System.Security.Claims, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class GenericPrincipal : System.Security.Claims.ClaimsPrincipal
            {
                public GenericPrincipal(System.Security.Principal.IIdentity identity, string[] roles) => throw null;
                public override System.Security.Principal.IIdentity Identity { get => throw null; }
                public override bool IsInRole(string role) => throw null;
            }

        }
    }
}
