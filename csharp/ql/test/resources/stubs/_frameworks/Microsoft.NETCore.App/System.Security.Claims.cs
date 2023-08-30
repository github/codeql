// This file contains auto-generated code.
// Generated from `System.Security.Claims, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Security
    {
        namespace Claims
        {
            public class Claim
            {
                public virtual System.Security.Claims.Claim Clone() => throw null;
                public virtual System.Security.Claims.Claim Clone(System.Security.Claims.ClaimsIdentity identity) => throw null;
                public Claim(System.IO.BinaryReader reader) => throw null;
                public Claim(System.IO.BinaryReader reader, System.Security.Claims.ClaimsIdentity subject) => throw null;
                protected Claim(System.Security.Claims.Claim other) => throw null;
                protected Claim(System.Security.Claims.Claim other, System.Security.Claims.ClaimsIdentity subject) => throw null;
                public Claim(string type, string value) => throw null;
                public Claim(string type, string value, string valueType) => throw null;
                public Claim(string type, string value, string valueType, string issuer) => throw null;
                public Claim(string type, string value, string valueType, string issuer, string originalIssuer) => throw null;
                public Claim(string type, string value, string valueType, string issuer, string originalIssuer, System.Security.Claims.ClaimsIdentity subject) => throw null;
                protected virtual byte[] CustomSerializationData { get => throw null; }
                public string Issuer { get => throw null; }
                public string OriginalIssuer { get => throw null; }
                public System.Collections.Generic.IDictionary<string, string> Properties { get => throw null; }
                public System.Security.Claims.ClaimsIdentity Subject { get => throw null; }
                public override string ToString() => throw null;
                public string Type { get => throw null; }
                public string Value { get => throw null; }
                public string ValueType { get => throw null; }
                public virtual void WriteTo(System.IO.BinaryWriter writer) => throw null;
                protected virtual void WriteTo(System.IO.BinaryWriter writer, byte[] userData) => throw null;
            }
            public class ClaimsIdentity : System.Security.Principal.IIdentity
            {
                public System.Security.Claims.ClaimsIdentity Actor { get => throw null; set { } }
                public virtual void AddClaim(System.Security.Claims.Claim claim) => throw null;
                public virtual void AddClaims(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                public virtual string AuthenticationType { get => throw null; }
                public object BootstrapContext { get => throw null; set { } }
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public virtual System.Security.Claims.ClaimsIdentity Clone() => throw null;
                protected virtual System.Security.Claims.Claim CreateClaim(System.IO.BinaryReader reader) => throw null;
                public ClaimsIdentity() => throw null;
                public ClaimsIdentity(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                public ClaimsIdentity(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, string authenticationType) => throw null;
                public ClaimsIdentity(System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, string authenticationType, string nameType, string roleType) => throw null;
                public ClaimsIdentity(System.IO.BinaryReader reader) => throw null;
                protected ClaimsIdentity(System.Runtime.Serialization.SerializationInfo info) => throw null;
                protected ClaimsIdentity(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                protected ClaimsIdentity(System.Security.Claims.ClaimsIdentity other) => throw null;
                public ClaimsIdentity(System.Security.Principal.IIdentity identity) => throw null;
                public ClaimsIdentity(System.Security.Principal.IIdentity identity, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims) => throw null;
                public ClaimsIdentity(System.Security.Principal.IIdentity identity, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, string authenticationType, string nameType, string roleType) => throw null;
                public ClaimsIdentity(string authenticationType) => throw null;
                public ClaimsIdentity(string authenticationType, string nameType, string roleType) => throw null;
                protected virtual byte[] CustomSerializationData { get => throw null; }
                public static string DefaultIssuer;
                public static string DefaultNameClaimType;
                public static string DefaultRoleClaimType;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> FindAll(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> FindAll(string type) => throw null;
                public virtual System.Security.Claims.Claim FindFirst(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual System.Security.Claims.Claim FindFirst(string type) => throw null;
                protected virtual void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public virtual bool HasClaim(System.Predicate<System.Security.Claims.Claim> match) => throw null;
                public virtual bool HasClaim(string type, string value) => throw null;
                public virtual bool IsAuthenticated { get => throw null; }
                public string Label { get => throw null; set { } }
                public virtual string Name { get => throw null; }
                public string NameClaimType { get => throw null; }
                public virtual void RemoveClaim(System.Security.Claims.Claim claim) => throw null;
                public string RoleClaimType { get => throw null; }
                public virtual bool TryRemoveClaim(System.Security.Claims.Claim claim) => throw null;
                public virtual void WriteTo(System.IO.BinaryWriter writer) => throw null;
                protected virtual void WriteTo(System.IO.BinaryWriter writer, byte[] userData) => throw null;
            }
            public class ClaimsPrincipal : System.Security.Principal.IPrincipal
            {
                public virtual void AddIdentities(System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity> identities) => throw null;
                public virtual void AddIdentity(System.Security.Claims.ClaimsIdentity identity) => throw null;
                public virtual System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> Claims { get => throw null; }
                public static System.Func<System.Security.Claims.ClaimsPrincipal> ClaimsPrincipalSelector { get => throw null; set { } }
                public virtual System.Security.Claims.ClaimsPrincipal Clone() => throw null;
                protected virtual System.Security.Claims.ClaimsIdentity CreateClaimsIdentity(System.IO.BinaryReader reader) => throw null;
                public ClaimsPrincipal() => throw null;
                public ClaimsPrincipal(System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity> identities) => throw null;
                public ClaimsPrincipal(System.IO.BinaryReader reader) => throw null;
                protected ClaimsPrincipal(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public ClaimsPrincipal(System.Security.Principal.IIdentity identity) => throw null;
                public ClaimsPrincipal(System.Security.Principal.IPrincipal principal) => throw null;
                public static System.Security.Claims.ClaimsPrincipal Current { get => throw null; }
                protected virtual byte[] CustomSerializationData { get => throw null; }
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
                public static System.Func<System.Collections.Generic.IEnumerable<System.Security.Claims.ClaimsIdentity>, System.Security.Claims.ClaimsIdentity> PrimaryIdentitySelector { get => throw null; set { } }
                public virtual void WriteTo(System.IO.BinaryWriter writer) => throw null;
                protected virtual void WriteTo(System.IO.BinaryWriter writer, byte[] userData) => throw null;
            }
            public static class ClaimTypes
            {
                public static string Actor;
                public static string Anonymous;
                public static string Authentication;
                public static string AuthenticationInstant;
                public static string AuthenticationMethod;
                public static string AuthorizationDecision;
                public static string CookiePath;
                public static string Country;
                public static string DateOfBirth;
                public static string DenyOnlyPrimaryGroupSid;
                public static string DenyOnlyPrimarySid;
                public static string DenyOnlySid;
                public static string DenyOnlyWindowsDeviceGroup;
                public static string Dns;
                public static string Dsa;
                public static string Email;
                public static string Expiration;
                public static string Expired;
                public static string Gender;
                public static string GivenName;
                public static string GroupSid;
                public static string Hash;
                public static string HomePhone;
                public static string IsPersistent;
                public static string Locality;
                public static string MobilePhone;
                public static string Name;
                public static string NameIdentifier;
                public static string OtherPhone;
                public static string PostalCode;
                public static string PrimaryGroupSid;
                public static string PrimarySid;
                public static string Role;
                public static string Rsa;
                public static string SerialNumber;
                public static string Sid;
                public static string Spn;
                public static string StateOrProvince;
                public static string StreetAddress;
                public static string Surname;
                public static string System;
                public static string Thumbprint;
                public static string Upn;
                public static string Uri;
                public static string UserData;
                public static string Version;
                public static string Webpage;
                public static string WindowsAccountName;
                public static string WindowsDeviceClaim;
                public static string WindowsDeviceGroup;
                public static string WindowsFqbnVersion;
                public static string WindowsSubAuthority;
                public static string WindowsUserClaim;
                public static string X500DistinguishedName;
            }
            public static class ClaimValueTypes
            {
                public static string Base64Binary;
                public static string Base64Octet;
                public static string Boolean;
                public static string Date;
                public static string DateTime;
                public static string DaytimeDuration;
                public static string DnsName;
                public static string Double;
                public static string DsaKeyValue;
                public static string Email;
                public static string Fqbn;
                public static string HexBinary;
                public static string Integer;
                public static string Integer32;
                public static string Integer64;
                public static string KeyInfo;
                public static string Rfc822Name;
                public static string Rsa;
                public static string RsaKeyValue;
                public static string Sid;
                public static string String;
                public static string Time;
                public static string UInteger32;
                public static string UInteger64;
                public static string UpnName;
                public static string X500Name;
                public static string YearMonthDuration;
            }
        }
        namespace Principal
        {
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
            public class GenericPrincipal : System.Security.Claims.ClaimsPrincipal
            {
                public GenericPrincipal(System.Security.Principal.IIdentity identity, string[] roles) => throw null;
                public override System.Security.Principal.IIdentity Identity { get => throw null; }
                public override bool IsInRole(string role) => throw null;
            }
        }
    }
}
