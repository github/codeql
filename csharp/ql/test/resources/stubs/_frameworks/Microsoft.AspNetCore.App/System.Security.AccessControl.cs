// This file contains auto-generated code.

namespace System
{
    namespace Diagnostics
    {
        namespace CodeAnalysis
        {
            /* Duplicate type 'AllowNullAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'DisallowNullAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'DoesNotReturnAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'DoesNotReturnIfAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MaybeNullAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MaybeNullWhenAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MemberNotNullAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'MemberNotNullWhenAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'NotNullAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'NotNullIfNotNullAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'NotNullWhenAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

        }
    }
    namespace Runtime
    {
        namespace Versioning
        {
            /* Duplicate type 'OSPlatformAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'SupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'TargetPlatformAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

            /* Duplicate type 'UnsupportedOSPlatformAttribute' is not stubbed in this assembly 'System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'. */

        }
    }
    namespace Security
    {
        namespace AccessControl
        {
            // Generated from `System.Security.AccessControl.AccessControlActions` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum AccessControlActions
            {
                Change,
                None,
                View,
            }

            // Generated from `System.Security.AccessControl.AccessControlModification` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AccessControlModification
            {
                Add,
                Remove,
                RemoveAll,
                RemoveSpecific,
                Reset,
                Set,
            }

            // Generated from `System.Security.AccessControl.AccessControlSections` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum AccessControlSections
            {
                Access,
                All,
                Audit,
                Group,
                None,
                Owner,
            }

            // Generated from `System.Security.AccessControl.AccessControlType` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AccessControlType
            {
                Allow,
                Deny,
            }

            // Generated from `System.Security.AccessControl.AccessRule` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AccessRule : System.Security.AccessControl.AuthorizationRule
            {
                public System.Security.AccessControl.AccessControlType AccessControlType { get => throw null; }
                protected AccessRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags)) => throw null;
            }

            // Generated from `System.Security.AccessControl.AccessRule<>` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AccessRule<T> : System.Security.AccessControl.AccessRule where T : struct
            {
                public AccessRule(string identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public AccessRule(string identity, T rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public AccessRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public AccessRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public T Rights { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.AceEnumerator` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AceEnumerator : System.Collections.IEnumerator
            {
                public System.Security.AccessControl.GenericAce Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            // Generated from `System.Security.AccessControl.AceFlags` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum AceFlags
            {
                AuditFlags,
                ContainerInherit,
                FailedAccess,
                InheritOnly,
                InheritanceFlags,
                Inherited,
                NoPropagateInherit,
                None,
                ObjectInherit,
                SuccessfulAccess,
            }

            // Generated from `System.Security.AccessControl.AceQualifier` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AceQualifier
            {
                AccessAllowed,
                AccessDenied,
                SystemAlarm,
                SystemAudit,
            }

            // Generated from `System.Security.AccessControl.AceType` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum AceType
            {
                AccessAllowed,
                AccessAllowedCallback,
                AccessAllowedCallbackObject,
                AccessAllowedCompound,
                AccessAllowedObject,
                AccessDenied,
                AccessDeniedCallback,
                AccessDeniedCallbackObject,
                AccessDeniedObject,
                MaxDefinedAceType,
                SystemAlarm,
                SystemAlarmCallback,
                SystemAlarmCallbackObject,
                SystemAlarmObject,
                SystemAudit,
                SystemAuditCallback,
                SystemAuditCallbackObject,
                SystemAuditObject,
            }

            // Generated from `System.Security.AccessControl.AuditFlags` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum AuditFlags
            {
                Failure,
                None,
                Success,
            }

            // Generated from `System.Security.AccessControl.AuditRule` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AuditRule : System.Security.AccessControl.AuthorizationRule
            {
                public System.Security.AccessControl.AuditFlags AuditFlags { get => throw null; }
                protected AuditRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags auditFlags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags)) => throw null;
            }

            // Generated from `System.Security.AccessControl.AuditRule<>` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AuditRule<T> : System.Security.AccessControl.AuditRule where T : struct
            {
                public AuditRule(string identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public AuditRule(string identity, T rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public AuditRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public AuditRule(System.Security.Principal.IdentityReference identity, T rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public T Rights { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.AuthorizationRule` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class AuthorizationRule
            {
                protected internal int AccessMask { get => throw null; }
                protected internal AuthorizationRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public System.Security.Principal.IdentityReference IdentityReference { get => throw null; }
                public System.Security.AccessControl.InheritanceFlags InheritanceFlags { get => throw null; }
                public bool IsInherited { get => throw null; }
                public System.Security.AccessControl.PropagationFlags PropagationFlags { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.AuthorizationRuleCollection` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class AuthorizationRuleCollection : System.Collections.ReadOnlyCollectionBase
            {
                public void AddRule(System.Security.AccessControl.AuthorizationRule rule) => throw null;
                public AuthorizationRuleCollection() => throw null;
                public void CopyTo(System.Security.AccessControl.AuthorizationRule[] rules, int index) => throw null;
                public System.Security.AccessControl.AuthorizationRule this[int index] { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.CommonAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CommonAce : System.Security.AccessControl.QualifiedAce
            {
                public override int BinaryLength { get => throw null; }
                public CommonAce(System.Security.AccessControl.AceFlags flags, System.Security.AccessControl.AceQualifier qualifier, int accessMask, System.Security.Principal.SecurityIdentifier sid, bool isCallback, System.Byte[] opaque) => throw null;
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
                public static int MaxOpaqueLength(bool isCallback) => throw null;
            }

            // Generated from `System.Security.AccessControl.CommonAcl` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.CommonObjectSecurity` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.CommonSecurityDescriptor` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CommonSecurityDescriptor : System.Security.AccessControl.GenericSecurityDescriptor
            {
                public void AddDiscretionaryAcl(System.Byte revision, int trusted) => throw null;
                public void AddSystemAcl(System.Byte revision, int trusted) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, string sddlForm) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Security.AccessControl.RawSecurityDescriptor rawSecurityDescriptor) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Security.AccessControl.ControlFlags flags, System.Security.Principal.SecurityIdentifier owner, System.Security.Principal.SecurityIdentifier group, System.Security.AccessControl.SystemAcl systemAcl, System.Security.AccessControl.DiscretionaryAcl discretionaryAcl) => throw null;
                public CommonSecurityDescriptor(bool isContainer, bool isDS, System.Byte[] binaryForm, int offset) => throw null;
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

            // Generated from `System.Security.AccessControl.CompoundAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class CompoundAce : System.Security.AccessControl.KnownAce
            {
                public override int BinaryLength { get => throw null; }
                public CompoundAce(System.Security.AccessControl.AceFlags flags, int accessMask, System.Security.AccessControl.CompoundAceType compoundAceType, System.Security.Principal.SecurityIdentifier sid) => throw null;
                public System.Security.AccessControl.CompoundAceType CompoundAceType { get => throw null; set => throw null; }
                public override void GetBinaryForm(System.Byte[] binaryForm, int offset) => throw null;
            }

            // Generated from `System.Security.AccessControl.CompoundAceType` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum CompoundAceType
            {
                Impersonation,
            }

            // Generated from `System.Security.AccessControl.ControlFlags` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum ControlFlags
            {
                DiscretionaryAclAutoInheritRequired,
                DiscretionaryAclAutoInherited,
                DiscretionaryAclDefaulted,
                DiscretionaryAclPresent,
                DiscretionaryAclProtected,
                DiscretionaryAclUntrusted,
                GroupDefaulted,
                None,
                OwnerDefaulted,
                RMControlValid,
                SelfRelative,
                ServerSecurity,
                SystemAclAutoInheritRequired,
                SystemAclAutoInherited,
                SystemAclDefaulted,
                SystemAclPresent,
                SystemAclProtected,
            }

            // Generated from `System.Security.AccessControl.CustomAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.DiscretionaryAcl` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DiscretionaryAcl : System.Security.AccessControl.CommonAcl
            {
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void AddAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, int capacity) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, System.Security.AccessControl.RawAcl rawAcl) => throw null;
                public DiscretionaryAcl(bool isContainer, bool isDS, System.Byte revision, int capacity) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public bool RemoveAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void RemoveAccessSpecific(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void SetAccess(System.Security.AccessControl.AccessControlType accessType, System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAccessRule rule) => throw null;
            }

            // Generated from `System.Security.AccessControl.GenericAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.GenericAcl` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class GenericAcl : System.Collections.IEnumerable, System.Collections.ICollection
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

            // Generated from `System.Security.AccessControl.GenericSecurityDescriptor` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.InheritanceFlags` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum InheritanceFlags
            {
                ContainerInherit,
                None,
                ObjectInherit,
            }

            // Generated from `System.Security.AccessControl.KnownAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class KnownAce : System.Security.AccessControl.GenericAce
            {
                public int AccessMask { get => throw null; set => throw null; }
                internal KnownAce() => throw null;
                public System.Security.Principal.SecurityIdentifier SecurityIdentifier { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.AccessControl.NativeObjectSecurity` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class NativeObjectSecurity : System.Security.AccessControl.CommonObjectSecurity
            {
                // Generated from `System.Security.AccessControl.NativeObjectSecurity+ExceptionFromErrorCode` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
                protected internal delegate System.Exception ExceptionFromErrorCode(int errorCode, string name, System.Runtime.InteropServices.SafeHandle handle, object context);


                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool)) => throw null;
                protected NativeObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType) : base(default(bool)) => throw null;
                protected void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections, object exceptionContext) => throw null;
                protected void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections, object exceptionContext) => throw null;
                protected override void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected override void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            }

            // Generated from `System.Security.AccessControl.ObjectAccessRule` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ObjectAccessRule : System.Security.AccessControl.AccessRule
            {
                public System.Guid InheritedObjectType { get => throw null; }
                protected ObjectAccessRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Guid objectType, System.Guid inheritedObjectType, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.ObjectAceFlags ObjectFlags { get => throw null; }
                public System.Guid ObjectType { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.ObjectAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.ObjectAceFlags` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum ObjectAceFlags
            {
                InheritedObjectAceTypePresent,
                None,
                ObjectAceTypePresent,
            }

            // Generated from `System.Security.AccessControl.ObjectAuditRule` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ObjectAuditRule : System.Security.AccessControl.AuditRule
            {
                public System.Guid InheritedObjectType { get => throw null; }
                protected ObjectAuditRule(System.Security.Principal.IdentityReference identity, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Guid objectType, System.Guid inheritedObjectType, System.Security.AccessControl.AuditFlags auditFlags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.ObjectAceFlags ObjectFlags { get => throw null; }
                public System.Guid ObjectType { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.ObjectSecurity` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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
                protected ObjectSecurity(bool isContainer, bool isDS) => throw null;
                protected ObjectSecurity(System.Security.AccessControl.CommonSecurityDescriptor securityDescriptor) => throw null;
                protected ObjectSecurity() => throw null;
                protected bool OwnerModified { get => throw null; set => throw null; }
                protected virtual void Persist(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected virtual void Persist(bool enableOwnershipPrivilege, string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                protected virtual void Persist(System.Runtime.InteropServices.SafeHandle handle, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public virtual void PurgeAccessRules(System.Security.Principal.IdentityReference identity) => throw null;
                public virtual void PurgeAuditRules(System.Security.Principal.IdentityReference identity) => throw null;
                protected void ReadLock() => throw null;
                protected void ReadUnlock() => throw null;
                protected System.Security.AccessControl.CommonSecurityDescriptor SecurityDescriptor { get => throw null; }
                public void SetAccessRuleProtection(bool isProtected, bool preserveInheritance) => throw null;
                public void SetAuditRuleProtection(bool isProtected, bool preserveInheritance) => throw null;
                public void SetGroup(System.Security.Principal.IdentityReference identity) => throw null;
                public void SetOwner(System.Security.Principal.IdentityReference identity) => throw null;
                public void SetSecurityDescriptorBinaryForm(System.Byte[] binaryForm, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public void SetSecurityDescriptorBinaryForm(System.Byte[] binaryForm) => throw null;
                public void SetSecurityDescriptorSddlForm(string sddlForm, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
                public void SetSecurityDescriptorSddlForm(string sddlForm) => throw null;
                protected void WriteLock() => throw null;
                protected void WriteUnlock() => throw null;
            }

            // Generated from `System.Security.AccessControl.ObjectSecurity<>` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class ObjectSecurity<T> : System.Security.AccessControl.NativeObjectSecurity where T : struct
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public virtual void AddAccessRule(System.Security.AccessControl.AccessRule<T> rule) => throw null;
                public virtual void AddAuditRule(System.Security.AccessControl.AuditRule<T> rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle safeHandle, System.Security.AccessControl.AccessControlSections includeSections, System.Security.AccessControl.NativeObjectSecurity.ExceptionFromErrorCode exceptionFromErrorCode, object exceptionContext) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType, System.Runtime.InteropServices.SafeHandle safeHandle, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected ObjectSecurity(bool isContainer, System.Security.AccessControl.ResourceType resourceType) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected internal void Persist(string name) => throw null;
                protected internal void Persist(System.Runtime.InteropServices.SafeHandle handle) => throw null;
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

            // Generated from `System.Security.AccessControl.PrivilegeNotHeldException` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PrivilegeNotHeldException : System.UnauthorizedAccessException, System.Runtime.Serialization.ISerializable
            {
                public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public string PrivilegeName { get => throw null; }
                public PrivilegeNotHeldException(string privilege, System.Exception inner) => throw null;
                public PrivilegeNotHeldException(string privilege) => throw null;
                public PrivilegeNotHeldException() => throw null;
            }

            // Generated from `System.Security.AccessControl.PropagationFlags` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum PropagationFlags
            {
                InheritOnly,
                NoPropagateInherit,
                None,
            }

            // Generated from `System.Security.AccessControl.QualifiedAce` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class QualifiedAce : System.Security.AccessControl.KnownAce
            {
                public System.Security.AccessControl.AceQualifier AceQualifier { get => throw null; }
                public System.Byte[] GetOpaque() => throw null;
                public bool IsCallback { get => throw null; }
                public int OpaqueLength { get => throw null; }
                internal QualifiedAce() => throw null;
                public void SetOpaque(System.Byte[] opaque) => throw null;
            }

            // Generated from `System.Security.AccessControl.RawAcl` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.RawSecurityDescriptor` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RawSecurityDescriptor : System.Security.AccessControl.GenericSecurityDescriptor
            {
                public override System.Security.AccessControl.ControlFlags ControlFlags { get => throw null; }
                public System.Security.AccessControl.RawAcl DiscretionaryAcl { get => throw null; set => throw null; }
                public override System.Security.Principal.SecurityIdentifier Group { get => throw null; set => throw null; }
                public override System.Security.Principal.SecurityIdentifier Owner { get => throw null; set => throw null; }
                public RawSecurityDescriptor(string sddlForm) => throw null;
                public RawSecurityDescriptor(System.Security.AccessControl.ControlFlags flags, System.Security.Principal.SecurityIdentifier owner, System.Security.Principal.SecurityIdentifier group, System.Security.AccessControl.RawAcl systemAcl, System.Security.AccessControl.RawAcl discretionaryAcl) => throw null;
                public RawSecurityDescriptor(System.Byte[] binaryForm, int offset) => throw null;
                public System.Byte ResourceManagerControl { get => throw null; set => throw null; }
                public void SetFlags(System.Security.AccessControl.ControlFlags flags) => throw null;
                public System.Security.AccessControl.RawAcl SystemAcl { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.AccessControl.ResourceType` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public enum ResourceType
            {
                DSObject,
                DSObjectAll,
                FileObject,
                KernelObject,
                LMShare,
                Printer,
                ProviderDefined,
                RegistryKey,
                RegistryWow6432Key,
                Service,
                Unknown,
                WindowObject,
                WmiGuidObject,
            }

            // Generated from `System.Security.AccessControl.SecurityInfos` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum SecurityInfos
            {
                DiscretionaryAcl,
                Group,
                Owner,
                SystemAcl,
            }

            // Generated from `System.Security.AccessControl.SystemAcl` in `System.Security.AccessControl, Version=5.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SystemAcl : System.Security.AccessControl.CommonAcl
            {
                public void AddAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void AddAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void AddAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public bool RemoveAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public bool RemoveAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public bool RemoveAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void RemoveAuditSpecific(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void RemoveAuditSpecific(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void RemoveAuditSpecific(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public void SetAudit(System.Security.Principal.SecurityIdentifier sid, System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public void SetAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.ObjectAceFlags objectFlags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                public void SetAudit(System.Security.AccessControl.AuditFlags auditFlags, System.Security.Principal.SecurityIdentifier sid, int accessMask, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags) => throw null;
                public SystemAcl(bool isContainer, bool isDS, int capacity) => throw null;
                public SystemAcl(bool isContainer, bool isDS, System.Security.AccessControl.RawAcl rawAcl) => throw null;
                public SystemAcl(bool isContainer, bool isDS, System.Byte revision, int capacity) => throw null;
            }

        }
    }
}
