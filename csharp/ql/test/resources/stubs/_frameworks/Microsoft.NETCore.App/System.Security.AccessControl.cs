// This file contains auto-generated code.
// Generated from `System.Security.AccessControl, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Security
    {
        namespace AccessControl
        {
            [System.Flags]
            public enum AccessControlActions
            {
                None = 0,
                View = 1,
                Change = 2,
            }
            public enum AccessControlModification
            {
                Add = 0,
                Set = 1,
                Reset = 2,
                Remove = 3,
                RemoveAll = 4,
                RemoveSpecific = 5,
            }
            [System.Flags]
            public enum AccessControlSections
            {
                None = 0,
                Audit = 1,
                Access = 2,
                Owner = 4,
                Group = 8,
                All = 15,
            }
            public enum AccessControlType
            {
                Allow = 0,
                Deny = 1,
            }
            public abstract class AccessRule : System.Security.AccessControl.AuthorizationRule
            {
                public System.Security.AccessControl.AccessControlType AccessControlType { get => throw null; }
                protected AccessRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags)) => throw null;
            }
            public class AccessRule<T> : System.Security.AccessControl.AccessRule where T : struct
            {
                public AccessRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public AccessRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public AccessRule(string identity, T rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public AccessRule(string identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public T Rights { get => throw null; }
            }
            public sealed class AceEnumerator : System.Collections.IEnumerator
            {
                public System.Security.AccessControl.GenericAce Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            [System.Flags]
            public enum AceFlags : byte
            {
                None = 0,
                ObjectInherit = 1,
                ContainerInherit = 2,
                NoPropagateInherit = 4,
                InheritOnly = 8,
                InheritanceFlags = 15,
                Inherited = 16,
                SuccessfulAccess = 64,
                FailedAccess = 128,
                AuditFlags = 192,
            }
            public enum AceQualifier
            {
                AccessAllowed = 0,
                AccessDenied = 1,
                SystemAudit = 2,
                SystemAlarm = 3,
            }
            public enum AceType : byte
            {
                AccessAllowed = 0,
                AccessDenied = 1,
                SystemAudit = 2,
                SystemAlarm = 3,
                AccessAllowedCompound = 4,
                AccessAllowedObject = 5,
                AccessDeniedObject = 6,
                SystemAuditObject = 7,
                SystemAlarmObject = 8,
                AccessAllowedCallback = 9,
                AccessDeniedCallback = 10,
                AccessAllowedCallbackObject = 11,
                AccessDeniedCallbackObject = 12,
                SystemAuditCallback = 13,
                SystemAlarmCallback = 14,
                SystemAuditCallbackObject = 15,
                MaxDefinedAceType = 16,
                SystemAlarmCallbackObject = 16,
            }
            [System.Flags]
            public enum AuditFlags
            {
                None = 0,
                Success = 1,
                Failure = 2,
            }
            public abstract class AuditRule : System.Security.AccessControl.AuthorizationRule
            {
                public System.Security.AccessControl.AuditFlags AuditFlags { get => throw null; }
                protected AuditRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags auditFlags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags)) => throw null;
            }
            public class AuditRule<T> : System.Security.AccessControl.AuditRule where T : struct
            {
                public AuditRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public AuditRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public AuditRule(string identity, T rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public AuditRule(string identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public T Rights { get => throw null; }
            }
            public abstract class AuthorizationRule
            {
                protected int AccessMask { get => throw null; }
                protected AuthorizationRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public System.Security.Principal.IdentityReference IdentityReference { get => throw null; }
                public System.Security.AccessControl.InheritanceFlags InheritanceFlags { get => throw null; }
                public bool IsInherited { get => throw null; }
                public System.Security.AccessControl.PropagationFlags PropagationFlags { get => throw null; }
            }
            public sealed class AuthorizationRuleCollection : System.Collections.ReadOnlyCollectionBase
            {
                public void AddRule(System.Security.AccessControl.AuthorizationRule rule) => throw null;
                public void CopyTo(System.Security.AccessControl.AuthorizationRule[] rules, int index) => throw null;
                public AuthorizationRuleCollection() => throw null;
                public System.Security.AccessControl.AuthorizationRule this[int index] { get => throw null; }
            }
            public sealed class CommonAce : System.Security.AccessControl.QualifiedAce
            {
                public override int BinaryLength { get => throw null; }
                public CommonAce(System.Security.AccessControl.AceFlags flags, System.Security.AccessControl.AceQualifier qualifier, int accessMask, System.Security.Principal.SecurityIdentifier sid, bool isCallback, byte[] opaque) => throw null;
                public override void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public static int MaxOpaqueLength(bool isCallback) => throw null;
            }
            public abstract class CommonAcl : System.Security.AccessControl.GenericAcl
            {
                public override sealed int BinaryLength { get => throw null; }
                public override sealed int Count { get => throw null; }
                public override sealed void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public bool IsCanonical { get => throw null; }
                public bool IsContainer { get => throw null; }
                public bool IsDS { get => throw null; }
                public void Purge(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void RemoveInheritedAces() => throw null;
                public override sealed byte Revision { get => throw null; }
                public override sealed System.Security.AccessControl.GenericAce this[int index] { get => throw null; set { } }
            }
            public abstract class CommonObjectSecurity : System.Security.AccessControl.ObjectSecurity
            {
                protected void AddAccessRule(System.Security.AccessControl.AccessRule rule) => throw null;
                protected void AddAuditRule(System.Security.AccessControl.AuditRule rule) => throw null;
                protected CommonObjectSecurity(bool isContainer) => throw null;
                public System.Security.AccessControl.AuthorizationRuleCollection GetAccessRules(bool includeExplicit, bool includeInherited, System.Type targetType) => throw null;
                public System.Security.AccessControl.AuthorizationRuleCollection GetAuditRules(bool includeExplicit, bool includeInherited, System.Type targetType) => throw null;
                protected override bool ModifyAccess(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AccessRule rule, out bool modified) => throw null;
                protected override bool ModifyAudit(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AuditRule rule, out bool modified) => throw null;
                protected bool RemoveAccessRule(System.Security.AccessControl.AccessRule rule) => throw null;
                protected void RemoveAccessRuleAll(System.Security.AccessControl.AccessRule rule) => throw null;
                protected void RemoveAccessRuleSpecific(System.Security.AccessControl.AccessRule rule) => throw null;
                protected bool RemoveAuditRule(System.Security.AccessControl.AuditRule rule) => throw null;
                protected void RemoveAuditRuleAll(System.Security.AccessControl.AuditRule rule) => throw null;
                protected void RemoveAuditRuleSpecific(System.Security.AccessControl.AuditRule rule) => throw null;
                protected void ResetAccessRule(System.Security.AccessControl.AccessRule rule) => throw null;
                protected void SetAccessRule(System.Security.AccessControl.AccessRule rule) => throw null;
                protected void SetAuditRule(System.Security.AccessControl.AuditRule rule) => throw null;
            }
            public sealed class CommonSecurityDescriptor : System.Security.AccessControl.GenericSecurityDescriptor
            {
                public void AddDiscretionaryAcl(byte revision, int trusted) => throw null;
                public void AddSystemAcl(byte revision, int trusted) => throw null;
                public override System.Security.AccessControl.ControlFlags ControlFlags { get => throw null; }
                public CommonSecurityDescriptor(bool isContainer, bool isDS, byte[] binaryForm, int offset) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Security.AccessControl.ControlFlags flags, System.Security.Principal.SecurityIdentifier owner, System.Security.Principal.SecurityIdentifier group, System.Security.AccessControl.SystemAcl systemAcl, System.Security.AccessControl.DiscretionaryAcl discretionaryAcl) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Security.AccessControl.RawSecurityDescriptor rawSecurityDescriptor) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, string sddlForm) => throw null;
                public System.Security.AccessControl.DiscretionaryAcl DiscretionaryAcl { get => throw null; set { } }
                public override System.Security.Principal.SecurityIdentifier Group { get => throw null; set { } }
                public bool IsContainer { get => throw null; }
                public bool IsDiscretionaryAclCanonical { get => throw null; }
                public bool IsDS { get => throw null; }
                public bool IsSystemAclCanonical { get => throw null; }
                public override System.Security.Principal.SecurityIdentifier Owner { get => throw null; set { } }
                public void PurgeAccessControl(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void PurgeAudit(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void SetDiscretionaryAclProtection(bool isProtected, bool preserveInheritance) => throw null;
                public void SetSystemAclProtection(bool isProtected, bool preserveInheritance) => throw null;
                public System.Security.AccessControl.SystemAcl SystemAcl { get => throw null; set { } }
            }
            public sealed class CompoundAce : System.Security.AccessControl.KnownAce
            {
                public override int BinaryLength { get => throw null; }
                public System.Security.AccessControl.CompoundAceType CompoundAceType { get => throw null; set { } }
                public CompoundAce(System.Security.AccessControl.AceFlags flags, int accessMask, System.Security.AccessControl.CompoundAceType compoundAceType, System.Security.Principal.SecurityIdentifier sid) => throw null;
                public override void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
            }
            public enum CompoundAceType
            {
                Impersonation = 1,
            }
            [System.Flags]
            public enum ControlFlags
            {
                None = 0,
                OwnerDefaulted = 1,
                GroupDefaulted = 2,
                DiscretionaryAclPresent = 4,
                DiscretionaryAclDefaulted = 8,
                SystemAclPresent = 16,
                SystemAclDefaulted = 32,
                DiscretionaryAclUntrusted = 64,
                ServerSecurity = 128,
                DiscretionaryAclAutoInheritRequired = 256,
                SystemAclAutoInheritRequired = 512,
                DiscretionaryAclAutoInherited = 1024,
                SystemAclAutoInherited = 2048,
                DiscretionaryAclProtected = 4096,
                SystemAclProtected = 8192,
                RMControlValid = 16384,
                SelfRelative = 32768,
            }
            public sealed class CustomAce : System.Security.AccessControl.GenericAce
            {
                public override int BinaryLength { get => throw null; }
                public CustomAce(System.Security.AccessControl.AceType type, System.Security.AccessControl.AceFlags flags, byte[] opaque) => throw null;
                public override void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public byte[] GetOpaque() => throw null;
                public static readonly int MaxOpaqueLength;
                public int OpaqueLength { get => throw null; }
                public void SetOpaque(byte[] opaque) => throw null;
            }
            public sealed class DiscretionaryAcl : System.Security.AccessControl.CommonAcl
            {
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, byte revision, int capacity) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, int capacity) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, System.Security.AccessControl.RawAcl rawAcl) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
            }
            public abstract class GenericAce
            {
                public System.Security.AccessControl.AceFlags AceFlags { get => throw null; set { } }
                public System.Security.AccessControl.AceType AceType { get => throw null; }
                public System.Security.AccessControl.AuditFlags AuditFlags { get => throw null; }
                public abstract int BinaryLength { get; }
                public System.Security.AccessControl.GenericAce Copy() => throw null;
                public static System.Security.AccessControl.GenericAce CreateFromBinaryForm(byte[] binaryForm, int offset) => throw null;
                public override sealed bool Equals(object o) => throw null;
                public abstract void GetBinaryForm(byte[] binaryForm, int offset);
                public override sealed int GetHashCode() => throw null;
                public System.Security.AccessControl.InheritanceFlags InheritanceFlags { get => throw null; }
                public bool IsInherited { get => throw null; }
                public static bool operator ==(System.Security.AccessControl.GenericAce left, System.Security.AccessControl.GenericAce right) => throw null;
                public static bool operator !=(System.Security.AccessControl.GenericAce left, System.Security.AccessControl.GenericAce right) => throw null;
                public System.Security.AccessControl.PropagationFlags PropagationFlags { get => throw null; }
            }
            public abstract class GenericAcl : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public static readonly byte AclRevision;
                public static readonly byte AclRevisionDS;
                public abstract int BinaryLength { get; }
                public void CopyTo(System.Security.AccessControl.GenericAce[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public abstract int Count { get; }
                protected GenericAcl() => throw null;
                public abstract void GetBinaryForm(byte[] binaryForm, int offset);
                public System.Security.AccessControl.AceEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public static readonly int MaxBinaryLength;
                public abstract byte Revision { get; }
                public virtual object SyncRoot { get => throw null; }
                public abstract System.Security.AccessControl.GenericAce this[int index] { get; set; }
            }
            public abstract class GenericSecurityDescriptor
            {
                public int BinaryLength { get => throw null; }
                public abstract System.Security.AccessControl.ControlFlags ControlFlags { get; }
                public void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public string GetSddlForm(System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public abstract System.Security.Principal.SecurityIdentifier Group { get; set; }
                public static bool IsSddlConversionSupported() => throw null;
                public abstract System.Security.Principal.SecurityIdentifier Owner { get; set; }
                public static byte Revision { get => throw null; }
            }
            [System.Flags]
            public enum InheritanceFlags
            {
                None = 0,
                ContainerInherit = 1,
                ObjectInherit = 2,
            }
            public abstract class KnownAce : System.Security.AccessControl.GenericAce
            {
                public int AccessMask { get => throw null; set { } }
                public System.Security.Principal.SecurityIdentifier SecurityIdentifier { get => throw null; set { } }
            }
            public abstract class NativeObjectSecurity : System.Security.AccessControl.CommonObjectSecurity
            {
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected delegate System.Exception ExceptionFromErrorCode(int errorCode, string name, System.Runtime.InteropServices.SafeHandle handle, object context);
                protected override sealed void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections, object exceptionContext) => throw null;
                protected override sealed void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections, object exceptionContext) => throw null;
            }
            public abstract class ObjectAccessRule : System.Security.AccessControl.AccessRule
            {
                protected ObjectAccessRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Guid objectType, System.Guid inheritedObjectType, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Guid InheritedObjectType { get => throw null; }
                public System.Security.AccessControl.ObjectAceFlags ObjectFlags { get => throw null; }
                public System.Guid ObjectType { get => throw null; }
            }
            public sealed class ObjectAce : System.Security.AccessControl.QualifiedAce
            {
                public override int BinaryLength { get => throw null; }
                public ObjectAce(System.Security.AccessControl.AceFlags aceFlags, System.Security.AccessControl.AceQualifier qualifier, int accessMask, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAceFlags flags, System.Guid type, System.Guid inheritedType, bool isCallback, byte[] opaque) => throw null;
                public override void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public System.Guid InheritedObjectAceType { get => throw null; set { } }
                public static int MaxOpaqueLength(bool isCallback) => throw null;
                public System.Security.AccessControl.ObjectAceFlags ObjectAceFlags { get => throw null; set { } }
                public System.Guid ObjectAceType { get => throw null; set { } }
            }
            [System.Flags]
            public enum ObjectAceFlags
            {
                None = 0,
                ObjectAceTypePresent = 1,
                InheritedObjectAceTypePresent = 2,
            }
            public abstract class ObjectAuditRule : System.Security.AccessControl.AuditRule
            {
                protected ObjectAuditRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Guid objectType, System.Guid inheritedObjectType, System.Security.AccessControl.AuditFlags auditFlags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Guid InheritedObjectType { get => throw null; }
                public System.Security.AccessControl.ObjectAceFlags ObjectFlags { get => throw null; }
                public System.Guid ObjectType { get => throw null; }
            }
            public abstract class ObjectSecurity
            {
                public abstract System.Type AccessRightType { get; }
                public abstract System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type);
                protected bool AccessRulesModified { get => throw null; set { } }
                public abstract System.Type AccessRuleType { get; }
                public bool AreAccessRulesCanonical { get => throw null; }
                public bool AreAccessRulesProtected { get => throw null; }
                public bool AreAuditRulesCanonical { get => throw null; }
                public bool AreAuditRulesProtected { get => throw null; }
                public abstract System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags);
                protected bool AuditRulesModified { get => throw null; set { } }
                public abstract System.Type AuditRuleType { get; }
                protected ObjectSecurity() => throw null;
                protected ObjectSecurity(bool isContainer, bool isDS) => throw null;
                protected ObjectSecurity(System.Security.AccessControl.CommonSecurityDescriptor securityDescriptor) => throw null;
                public System.Security.Principal.IdentityReference GetGroup(System.Type targetType) => throw null;
                public System.Security.Principal.IdentityReference GetOwner(System.Type targetType) => throw null;
                public byte[] GetSecurityDescriptorBinaryForm() => throw null;
                public string GetSecurityDescriptorSddlForm(System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected bool GroupModified { get => throw null; set { } }
                protected bool IsContainer { get => throw null; }
                protected bool IsDS { get => throw null; }
                public static bool IsSddlConversionSupported() => throw null;
                protected abstract bool ModifyAccess(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AccessRule rule, out bool modified);
                public virtual bool ModifyAccessRule(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AccessRule rule, out bool modified) => throw null;
                protected abstract bool ModifyAudit(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AuditRule rule, out bool modified);
                public virtual bool ModifyAuditRule(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AuditRule rule, out bool modified) => throw null;
                protected bool OwnerModified { get => throw null; set { } }
                protected virtual void Persist(bool enableOwnershipPrivilege, string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected virtual void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected virtual void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public virtual void PurgeAccessRules(System.Security.Principal.IdentityReference identity) => throw null;
                public virtual void PurgeAuditRules(System.Security.Principal.IdentityReference identity) => throw null;
                protected void ReadLock() => throw null;
                protected void ReadUnlock() => throw null;
                protected System.Security.AccessControl.CommonSecurityDescriptor SecurityDescriptor { get => throw null; }
                public void SetAccessRuleProtection(bool isProtected, bool preserveInheritance) => throw null;
                public void SetAuditRuleProtection(bool isProtected, bool preserveInheritance) => throw null;
                public void SetGroup(System.Security.Principal.IdentityReference identity) => throw null;
                public void SetOwner(System.Security.Principal.IdentityReference identity) => throw null;
                public void SetSecurityDescriptorBinaryForm(byte[] binaryForm) => throw null;
                public void SetSecurityDescriptorBinaryForm(byte[] binaryForm, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public void SetSecurityDescriptorSddlForm(string sddlForm) => throw null;
                public void SetSecurityDescriptorSddlForm(string sddlForm, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected void WriteLock() => throw null;
                protected void WriteUnlock() => throw null;
            }
            public abstract class ObjectSecurity<T> : System.Security.AccessControl.NativeObjectSecurity where T : struct
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public virtual void AddAccessRule(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual void AddAuditRule(System.Security.AccessControl.AuditRule<T> rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle safeHandle, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle safeHandle, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected void Persist(System.Runtime.InteropServices.SafeHandle handle) => throw null;
                protected void Persist(string name) => throw null;
                public virtual bool RemoveAccessRule(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual void RemoveAccessRuleAll(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual void RemoveAccessRuleSpecific(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual bool RemoveAuditRule(System.Security.AccessControl.AuditRule<T> rule) => throw null;
                public virtual void RemoveAuditRuleAll(System.Security.AccessControl.AuditRule<T> rule) => throw null;
                public virtual void RemoveAuditRuleSpecific(System.Security.AccessControl.AuditRule<T> rule) => throw null;
                public virtual void ResetAccessRule(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual void SetAccessRule(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual void SetAuditRule(System.Security.AccessControl.AuditRule<T> rule) => throw null;
            }
            public sealed class PrivilegeNotHeldException : System.UnauthorizedAccessException, System.Runtime.Serialization.ISerializable
            {
                public PrivilegeNotHeldException() => throw null;
                public PrivilegeNotHeldException(string privilege) => throw null;
                public PrivilegeNotHeldException(string privilege, System.Exception inner) => throw null;
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string PrivilegeName { get => throw null; }
            }
            [System.Flags]
            public enum PropagationFlags
            {
                None = 0,
                NoPropagateInherit = 1,
                InheritOnly = 2,
            }
            public abstract class QualifiedAce : System.Security.AccessControl.KnownAce
            {
                public System.Security.AccessControl.AceQualifier AceQualifier { get => throw null; }
                public byte[] GetOpaque() => throw null;
                public bool IsCallback { get => throw null; }
                public int OpaqueLength { get => throw null; }
                public void SetOpaque(byte[] opaque) => throw null;
            }
            public sealed class RawAcl : System.Security.AccessControl.GenericAcl
            {
                public override int BinaryLength { get => throw null; }
                public override int Count { get => throw null; }
                public RawAcl(byte revision, int capacity) => throw null;
                public RawAcl(byte[] binaryForm, int offset) => throw null;
                public override void GetBinaryForm(byte[] binaryForm, int offset) => throw null;
                public void InsertAce(int index, System.Security.AccessControl.GenericAce ace) => throw null;
                public void RemoveAce(int index) => throw null;
                public override byte Revision { get => throw null; }
                public override System.Security.AccessControl.GenericAce this[int index] { get => throw null; set { } }
            }
            public sealed class RawSecurityDescriptor : System.Security.AccessControl.GenericSecurityDescriptor
            {
                public override System.Security.AccessControl.ControlFlags ControlFlags { get => throw null; }
                public RawSecurityDescriptor(byte[] binaryForm, int offset) => throw null;
                public RawSecurityDescriptor(System.Security.AccessControl.ControlFlags flags, System.Security.Principal.SecurityIdentifier owner, System.Security.Principal.SecurityIdentifier group, System.Security.AccessControl.RawAcl systemAcl, System.Security.AccessControl.RawAcl discretionaryAcl) => throw null;
                public RawSecurityDescriptor(string sddlForm) => throw null;
                public System.Security.AccessControl.RawAcl DiscretionaryAcl { get => throw null; set { } }
                public override System.Security.Principal.SecurityIdentifier Group { get => throw null; set { } }
                public override System.Security.Principal.SecurityIdentifier Owner { get => throw null; set { } }
                public byte ResourceManagerControl { get => throw null; set { } }
                public void SetFlags(System.Security.AccessControl.ControlFlags flags) => throw null;
                public System.Security.AccessControl.RawAcl SystemAcl { get => throw null; set { } }
            }
            public enum ResourceType
            {
                Unknown = 0,
                FileObject = 1,
                Service = 2,
                Printer = 3,
                RegistryKey = 4,
                LMShare = 5,
                KernelObject = 6,
                WindowObject = 7,
                DSObject = 8,
                DSObjectAll = 9,
                ProviderDefined = 10,
                WmiGuidObject = 11,
                RegistryWow6432Key = 12,
            }
            [System.Flags]
            public enum SecurityInfos
            {
                Owner = 1,
                Group = 2,
                DiscretionaryAcl = 4,
                SystemAcl = 8,
            }
            public sealed class SystemAcl : System.Security.AccessControl.CommonAcl
            {
                public void AddAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void AddAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void AddAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public SystemAcl(bool isContainer, bool isDS, byte revision, int capacity) => throw null;
                public SystemAcl(bool isContainer, bool isDS, int capacity) => throw null;
                public SystemAcl(bool isContainer, bool isDS, System.Security.AccessControl.RawAcl rawAcl) => throw null;
                public bool RemoveAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public bool RemoveAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public bool RemoveAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void RemoveAuditSpecific(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void RemoveAuditSpecific(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void RemoveAuditSpecific(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void SetAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void SetAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void SetAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
            }
        }
        namespace Policy
        {
            public sealed class Evidence : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public void AddAssembly(object id) => throw null;
                public void AddAssemblyEvidence<T>(T evidence) where T : System.Security.Policy.EvidenceBase => throw null;
                public void AddHost(object id) => throw null;
                public void AddHostEvidence<T>(T evidence) where T : System.Security.Policy.EvidenceBase => throw null;
                public void Clear() => throw null;
                public System.Security.Policy.Evidence Clone() => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public Evidence() => throw null;
                public Evidence(object[] hostEvidence, object[] assemblyEvidence) => throw null;
                public Evidence(System.Security.Policy.Evidence evidence) => throw null;
                public Evidence(System.Security.Policy.EvidenceBase[] hostEvidence, System.Security.Policy.EvidenceBase[] assemblyEvidence) => throw null;
                public System.Collections.IEnumerator GetAssemblyEnumerator() => throw null;
                public T GetAssemblyEvidence<T>() where T : System.Security.Policy.EvidenceBase => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                public System.Collections.IEnumerator GetHostEnumerator() => throw null;
                public T GetHostEvidence<T>() where T : System.Security.Policy.EvidenceBase => throw null;
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                public bool Locked { get => throw null; set { } }
                public void Merge(System.Security.Policy.Evidence evidence) => throw null;
                public void RemoveType(System.Type t) => throw null;
                public object SyncRoot { get => throw null; }
            }
            public abstract class EvidenceBase
            {
                public virtual System.Security.Policy.EvidenceBase Clone() => throw null;
                protected EvidenceBase() => throw null;
            }
        }
    }
}
