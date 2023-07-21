// This file contains auto-generated code.
// Generated from `System.Security.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.

namespace System
{
    namespace Security
    {
        namespace AccessControl
        {
            [System.Flags]
            public enum AccessControlActions : int
            {
                Change = 2,
                None = 0,
                View = 1,
            }

            public enum AccessControlModification : int
            {
                Add = 0,
                Remove = 3,
                RemoveAll = 4,
                RemoveSpecific = 5,
                Reset = 2,
                Set = 1,
            }

            [System.Flags]
            public enum AccessControlSections : int
            {
                Access = 2,
                All = 15,
                Audit = 1,
                Group = 8,
                None = 0,
                Owner = 4,
            }

            public enum AccessControlType : int
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

            public class AceEnumerator : System.Collections.IEnumerator
            {
                public System.Security.AccessControl.GenericAce Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            [System.Flags]
            public enum AceFlags : byte
            {
                AuditFlags = 192,
                ContainerInherit = 2,
                FailedAccess = 128,
                InheritOnly = 8,
                InheritanceFlags = 15,
                Inherited = 16,
                NoPropagateInherit = 4,
                None = 0,
                ObjectInherit = 1,
                SuccessfulAccess = 64,
            }

            public enum AceQualifier : int
            {
                AccessAllowed = 0,
                AccessDenied = 1,
                SystemAlarm = 3,
                SystemAudit = 2,
            }

            public enum AceType : byte
            {
                AccessAllowed = 0,
                AccessAllowedCallback = 9,
                AccessAllowedCallbackObject = 11,
                AccessAllowedCompound = 4,
                AccessAllowedObject = 5,
                AccessDenied = 1,
                AccessDeniedCallback = 10,
                AccessDeniedCallbackObject = 12,
                AccessDeniedObject = 6,
                MaxDefinedAceType = 16,
                SystemAlarm = 3,
                SystemAlarmCallback = 14,
                SystemAlarmCallbackObject = 16,
                SystemAlarmObject = 8,
                SystemAudit = 2,
                SystemAuditCallback = 13,
                SystemAuditCallbackObject = 15,
                SystemAuditObject = 7,
            }

            [System.Flags]
            public enum AuditFlags : int
            {
                Failure = 2,
                None = 0,
                Success = 1,
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
                protected internal int AccessMask { get => throw null; }
                protected internal AuthorizationRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public System.Security.Principal.IdentityReference IdentityReference { get => throw null; }
                public System.Security.AccessControl.InheritanceFlags InheritanceFlags { get => throw null; }
                public bool IsInherited { get => throw null; }
                public System.Security.AccessControl.PropagationFlags PropagationFlags { get => throw null; }
            }

            public class AuthorizationRuleCollection : System.Collections.ReadOnlyCollectionBase
            {
                public void AddRule(System.Security.AccessControl.AuthorizationRule rule) => throw null;
                public AuthorizationRuleCollection() => throw null;
                public void CopyTo(System.Security.AccessControl.AuthorizationRule[] rules, int index) => throw null;
                public System.Security.AccessControl.AuthorizationRule this[int index] { get => throw null; }
            }

            public class CommonAce : System.Security.AccessControl.QualifiedAce
            {
                public override int BinaryLength { get => throw null; }
                public CommonAce(System.Security.AccessControl.AceFlags flags, System.Security.AccessControl.AceQualifier qualifier, int accessMask, System.Security.Principal.SecurityIdentifier sid, bool isCallback, System.Byte[] opaque) => throw null;
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public static int MaxOpaqueLength(bool isCallback) => throw null;
            }

            public abstract class CommonAcl : System.Security.AccessControl.GenericAcl
            {
                public override int BinaryLength { get => throw null; }
                internal CommonAcl() => throw null;
                public override int Count { get => throw null; }
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public bool IsCanonical { get => throw null; }
                public bool IsContainer { get => throw null; }
                public bool IsDS { get => throw null; }
                public override System.Security.AccessControl.GenericAce this[int index] { get => throw null; set => throw null; }
                public void Purge(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void RemoveInheritedAces() => throw null;
                public override System.Byte Revision { get => throw null; }
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

            public class CommonSecurityDescriptor : System.Security.AccessControl.GenericSecurityDescriptor
            {
                public void AddDiscretionaryAcl(System.Byte revision, int trusted) => throw null;
                public void AddSystemAcl(System.Byte revision, int trusted) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Byte[] binaryForm, int offset) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Security.AccessControl.ControlFlags flags, System.Security.Principal.SecurityIdentifier owner, System.Security.Principal.SecurityIdentifier group, System.Security.AccessControl.SystemAcl systemAcl, System.Security.AccessControl.DiscretionaryAcl discretionaryAcl) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Security.AccessControl.RawSecurityDescriptor rawSecurityDescriptor) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, string sddlForm) => throw null;
                public override System.Security.AccessControl.ControlFlags ControlFlags { get => throw null; }
                public System.Security.AccessControl.DiscretionaryAcl DiscretionaryAcl { get => throw null; set => throw null; }
                public override System.Security.Principal.SecurityIdentifier Group { get => throw null; set => throw null; }
                public bool IsContainer { get => throw null; }
                public bool IsDS { get => throw null; }
                public bool IsDiscretionaryAclCanonical { get => throw null; }
                public bool IsSystemAclCanonical { get => throw null; }
                public override System.Security.Principal.SecurityIdentifier Owner { get => throw null; set => throw null; }
                public void PurgeAccessControl(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void PurgeAudit(System.Security.Principal.SecurityIdentifier sid) => throw null;
                public void SetDiscretionaryAclProtection(bool isProtected, bool preserveInheritance) => throw null;
                public void SetSystemAclProtection(bool isProtected, bool preserveInheritance) => throw null;
                public System.Security.AccessControl.SystemAcl SystemAcl { get => throw null; set => throw null; }
            }

            public class CompoundAce : System.Security.AccessControl.KnownAce
            {
                public override int BinaryLength { get => throw null; }
                public CompoundAce(System.Security.AccessControl.AceFlags flags, int accessMask, System.Security.AccessControl.CompoundAceType compoundAceType, System.Security.Principal.SecurityIdentifier sid) => throw null;
                public System.Security.AccessControl.CompoundAceType CompoundAceType { get => throw null; set => throw null; }
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
            }

            public enum CompoundAceType : int
            {
                Impersonation = 1,
            }

            [System.Flags]
            public enum ControlFlags : int
            {
                DiscretionaryAclAutoInheritRequired = 256,
                DiscretionaryAclAutoInherited = 1024,
                DiscretionaryAclDefaulted = 8,
                DiscretionaryAclPresent = 4,
                DiscretionaryAclProtected = 4096,
                DiscretionaryAclUntrusted = 64,
                GroupDefaulted = 2,
                None = 0,
                OwnerDefaulted = 1,
                RMControlValid = 16384,
                SelfRelative = 32768,
                ServerSecurity = 128,
                SystemAclAutoInheritRequired = 512,
                SystemAclAutoInherited = 2048,
                SystemAclDefaulted = 32,
                SystemAclPresent = 16,
                SystemAclProtected = 8192,
            }

            public class CustomAce : System.Security.AccessControl.GenericAce
            {
                public override int BinaryLength { get => throw null; }
                public CustomAce(System.Security.AccessControl.AceType type, System.Security.AccessControl.AceFlags flags, System.Byte[] opaque) => throw null;
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public System.Byte[] GetOpaque() => throw null;
                public static int MaxOpaqueLength;
                public int OpaqueLength { get => throw null; }
                public void SetOpaque(System.Byte[] opaque) => throw null;
            }

            public class DiscretionaryAcl : System.Security.AccessControl.CommonAcl
            {
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, System.Security.AccessControl.RawAcl rawAcl) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, System.Byte revision, int capacity) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, int capacity) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
            }

            public abstract class GenericAce
            {
                public static bool operator !=(System.Security.AccessControl.GenericAce left, System.Security.AccessControl.GenericAce right) => throw null;
                public static bool operator ==(System.Security.AccessControl.GenericAce left, System.Security.AccessControl.GenericAce right) => throw null;
                public System.Security.AccessControl.AceFlags AceFlags { get => throw null; set => throw null; }
                public System.Security.AccessControl.AceType AceType { get => throw null; }
                public System.Security.AccessControl.AuditFlags AuditFlags { get => throw null; }
                public abstract int BinaryLength { get; }
                public System.Security.AccessControl.GenericAce Copy() => throw null;
                public static System.Security.AccessControl.GenericAce CreateFromBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public override bool Equals(object o) => throw null;
                internal GenericAce() => throw null;
                public abstract void GetBinaryForm(System.Byte[] binaryForm, int offset);
                public override int GetHashCode() => throw null;
                public System.Security.AccessControl.InheritanceFlags InheritanceFlags { get => throw null; }
                public bool IsInherited { get => throw null; }
                public System.Security.AccessControl.PropagationFlags PropagationFlags { get => throw null; }
            }

            public abstract class GenericAcl : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public static System.Byte AclRevision;
                public static System.Byte AclRevisionDS;
                public abstract int BinaryLength { get; }
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.AccessControl.GenericAce[] array, int index) => throw null;
                public abstract int Count { get; }
                protected GenericAcl() => throw null;
                public abstract void GetBinaryForm(System.Byte[] binaryForm, int offset);
                public System.Security.AccessControl.AceEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public abstract System.Security.AccessControl.GenericAce this[int index] { get; set; }
                public static int MaxBinaryLength;
                public abstract System.Byte Revision { get; }
                public virtual object SyncRoot { get => throw null; }
            }

            public abstract class GenericSecurityDescriptor
            {
                public int BinaryLength { get => throw null; }
                public abstract System.Security.AccessControl.ControlFlags ControlFlags { get; }
                internal GenericSecurityDescriptor() => throw null;
                public void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public string GetSddlForm(System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public abstract System.Security.Principal.SecurityIdentifier Group { get; set; }
                public static bool IsSddlConversionSupported() => throw null;
                public abstract System.Security.Principal.SecurityIdentifier Owner { get; set; }
                public static System.Byte Revision { get => throw null; }
            }

            [System.Flags]
            public enum InheritanceFlags : int
            {
                ContainerInherit = 1,
                None = 0,
                ObjectInherit = 2,
            }

            public abstract class KnownAce : System.Security.AccessControl.GenericAce
            {
                public int AccessMask { get => throw null; set => throw null; }
                internal KnownAce() => throw null;
                public System.Security.Principal.SecurityIdentifier SecurityIdentifier { get => throw null; set => throw null; }
            }

            public abstract class NativeObjectSecurity : System.Security.AccessControl.CommonObjectSecurity
            {
                protected internal delegate System.Exception ExceptionFromErrorCode(int errorCode, string name, System.Runtime.InteropServices.SafeHandle handle, object context);


                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected override void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections, object exceptionContext) => throw null;
                protected override void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections, object exceptionContext) => throw null;
            }

            public abstract class ObjectAccessRule : System.Security.AccessControl.AccessRule
            {
                public System.Guid InheritedObjectType { get => throw null; }
                protected ObjectAccessRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Guid objectType, System.Guid inheritedObjectType, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.ObjectAceFlags ObjectFlags { get => throw null; }
                public System.Guid ObjectType { get => throw null; }
            }

            public class ObjectAce : System.Security.AccessControl.QualifiedAce
            {
                public override int BinaryLength { get => throw null; }
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public System.Guid InheritedObjectAceType { get => throw null; set => throw null; }
                public static int MaxOpaqueLength(bool isCallback) => throw null;
                public ObjectAce(System.Security.AccessControl.AceFlags aceFlags, System.Security.AccessControl.AceQualifier qualifier, int accessMask, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAceFlags flags, System.Guid type, System.Guid inheritedType, bool isCallback, System.Byte[] opaque) => throw null;
                public System.Security.AccessControl.ObjectAceFlags ObjectAceFlags { get => throw null; set => throw null; }
                public System.Guid ObjectAceType { get => throw null; set => throw null; }
            }

            [System.Flags]
            public enum ObjectAceFlags : int
            {
                InheritedObjectAceTypePresent = 2,
                None = 0,
                ObjectAceTypePresent = 1,
            }

            public abstract class ObjectAuditRule : System.Security.AccessControl.AuditRule
            {
                public System.Guid InheritedObjectType { get => throw null; }
                protected ObjectAuditRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Guid objectType, System.Guid inheritedObjectType, System.Security.AccessControl.AuditFlags auditFlags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.ObjectAceFlags ObjectFlags { get => throw null; }
                public System.Guid ObjectType { get => throw null; }
            }

            public abstract class ObjectSecurity
            {
                public abstract System.Type AccessRightType { get; }
                public abstract System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type);
                public abstract System.Type AccessRuleType { get; }
                protected bool AccessRulesModified { get => throw null; set => throw null; }
                public bool AreAccessRulesCanonical { get => throw null; }
                public bool AreAccessRulesProtected { get => throw null; }
                public bool AreAuditRulesCanonical { get => throw null; }
                public bool AreAuditRulesProtected { get => throw null; }
                public abstract System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags);
                public abstract System.Type AuditRuleType { get; }
                protected bool AuditRulesModified { get => throw null; set => throw null; }
                public System.Security.Principal.IdentityReference GetGroup(System.Type targetType) => throw null;
                public System.Security.Principal.IdentityReference GetOwner(System.Type targetType) => throw null;
                public System.Byte[] GetSecurityDescriptorBinaryForm() => throw null;
                public string GetSecurityDescriptorSddlForm(System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected bool GroupModified { get => throw null; set => throw null; }
                protected bool IsContainer { get => throw null; }
                protected bool IsDS { get => throw null; }
                public static bool IsSddlConversionSupported() => throw null;
                protected abstract bool ModifyAccess(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AccessRule rule, out bool modified);
                public virtual bool ModifyAccessRule(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AccessRule rule, out bool modified) => throw null;
                protected abstract bool ModifyAudit(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AuditRule rule, out bool modified);
                public virtual bool ModifyAuditRule(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AuditRule rule, out bool modified) => throw null;
                protected ObjectSecurity() => throw null;
                protected ObjectSecurity(System.Security.AccessControl.CommonSecurityDescriptor securityDescriptor) => throw null;
                protected ObjectSecurity(bool isContainer, bool isDS) => throw null;
                protected bool OwnerModified { get => throw null; set => throw null; }
                protected virtual void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected virtual void Persist(bool enableOwnershipPrivilege, string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
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
                public void SetSecurityDescriptorBinaryForm(System.Byte[] binaryForm) => throw null;
                public void SetSecurityDescriptorBinaryForm(System.Byte[] binaryForm, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
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
                protected internal void Persist(System.Runtime.InteropServices.SafeHandle handle) => throw null;
                protected internal void Persist(string name) => throw null;
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

            public class PrivilegeNotHeldException : System.UnauthorizedAccessException, System.Runtime.Serialization.ISerializable
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string PrivilegeName { get => throw null; }
                public PrivilegeNotHeldException() => throw null;
                public PrivilegeNotHeldException(string privilege) => throw null;
                public PrivilegeNotHeldException(string privilege, System.Exception inner) => throw null;
            }

            [System.Flags]
            public enum PropagationFlags : int
            {
                InheritOnly = 2,
                NoPropagateInherit = 1,
                None = 0,
            }

            public abstract class QualifiedAce : System.Security.AccessControl.KnownAce
            {
                public System.Security.AccessControl.AceQualifier AceQualifier { get => throw null; }
                public System.Byte[] GetOpaque() => throw null;
                public bool IsCallback { get => throw null; }
                public int OpaqueLength { get => throw null; }
                internal QualifiedAce() => throw null;
                public void SetOpaque(System.Byte[] opaque) => throw null;
            }

            public class RawAcl : System.Security.AccessControl.GenericAcl
            {
                public override int BinaryLength { get => throw null; }
                public override int Count { get => throw null; }
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public void InsertAce(int index, System.Security.AccessControl.GenericAce ace) => throw null;
                public override System.Security.AccessControl.GenericAce this[int index] { get => throw null; set => throw null; }
                public RawAcl(System.Byte[] binaryForm, int offset) => throw null;
                public RawAcl(System.Byte revision, int capacity) => throw null;
                public void RemoveAce(int index) => throw null;
                public override System.Byte Revision { get => throw null; }
            }

            public class RawSecurityDescriptor : System.Security.AccessControl.GenericSecurityDescriptor
            {
                public override System.Security.AccessControl.ControlFlags ControlFlags { get => throw null; }
                public System.Security.AccessControl.RawAcl DiscretionaryAcl { get => throw null; set => throw null; }
                public override System.Security.Principal.SecurityIdentifier Group { get => throw null; set => throw null; }
                public override System.Security.Principal.SecurityIdentifier Owner { get => throw null; set => throw null; }
                public RawSecurityDescriptor(System.Byte[] binaryForm, int offset) => throw null;
                public RawSecurityDescriptor(System.Security.AccessControl.ControlFlags flags, System.Security.Principal.SecurityIdentifier owner, System.Security.Principal.SecurityIdentifier group, System.Security.AccessControl.RawAcl systemAcl, System.Security.AccessControl.RawAcl discretionaryAcl) => throw null;
                public RawSecurityDescriptor(string sddlForm) => throw null;
                public System.Byte ResourceManagerControl { get => throw null; set => throw null; }
                public void SetFlags(System.Security.AccessControl.ControlFlags flags) => throw null;
                public System.Security.AccessControl.RawAcl SystemAcl { get => throw null; set => throw null; }
            }

            public enum ResourceType : int
            {
                DSObject = 8,
                DSObjectAll = 9,
                FileObject = 1,
                KernelObject = 6,
                LMShare = 5,
                Printer = 3,
                ProviderDefined = 10,
                RegistryKey = 4,
                RegistryWow6432Key = 12,
                Service = 2,
                Unknown = 0,
                WindowObject = 7,
                WmiGuidObject = 11,
            }

            [System.Flags]
            public enum SecurityInfos : int
            {
                DiscretionaryAcl = 4,
                Group = 2,
                Owner = 1,
                SystemAcl = 8,
            }

            public class SystemAcl : System.Security.AccessControl.CommonAcl
            {
                public void AddAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void AddAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void AddAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public bool RemoveAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public bool RemoveAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public bool RemoveAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void RemoveAuditSpecific(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void RemoveAuditSpecific(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void RemoveAuditSpecific(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void SetAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void SetAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void SetAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public SystemAcl(bool isContainer, bool isDS, System.Security.AccessControl.RawAcl rawAcl) => throw null;
                public SystemAcl(bool isContainer, bool isDS, System.Byte revision, int capacity) => throw null;
                public SystemAcl(bool isContainer, bool isDS, int capacity) => throw null;
            }

        }
        namespace Policy
        {
            public class Evidence : System.Collections.ICollection, System.Collections.IEnumerable
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
                public Evidence(System.Security.Policy.Evidence evidence) => throw null;
                public Evidence(System.Security.Policy.EvidenceBase[] hostEvidence, System.Security.Policy.EvidenceBase[] assemblyEvidence) => throw null;
                public Evidence(object[] hostEvidence, object[] assemblyEvidence) => throw null;
                public System.Collections.IEnumerator GetAssemblyEnumerator() => throw null;
                public T GetAssemblyEvidence<T>() where T : System.Security.Policy.EvidenceBase => throw null;
                public System.Collections.IEnumerator GetEnumerator() => throw null;
                public System.Collections.IEnumerator GetHostEnumerator() => throw null;
                public T GetHostEvidence<T>() where T : System.Security.Policy.EvidenceBase => throw null;
                public bool IsReadOnly { get => throw null; }
                public bool IsSynchronized { get => throw null; }
                public bool Locked { get => throw null; set => throw null; }
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
