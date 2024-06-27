// This file contains auto-generated code.
// Generated from `System.IO.FileSystem.AccessControl, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace IO
    {
        public static partial class FileSystemAclExtensions
        {
            public static void Create(this System.IO.DirectoryInfo directoryInfo, System.Security.AccessControl.DirectorySecurity directorySecurity) => throw null;
            public static System.IO.FileStream Create(this System.IO.FileInfo fileInfo, System.IO.FileMode mode, System.Security.AccessControl.FileSystemRights rights, System.IO.FileShare share, int bufferSize, System.IO.FileOptions options, System.Security.AccessControl.FileSecurity fileSecurity) => throw null;
            public static System.IO.DirectoryInfo CreateDirectory(this System.Security.AccessControl.DirectorySecurity directorySecurity, string path) => throw null;
            public static System.Security.AccessControl.DirectorySecurity GetAccessControl(this System.IO.DirectoryInfo directoryInfo) => throw null;
            public static System.Security.AccessControl.DirectorySecurity GetAccessControl(this System.IO.DirectoryInfo directoryInfo, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            public static System.Security.AccessControl.FileSecurity GetAccessControl(this System.IO.FileInfo fileInfo) => throw null;
            public static System.Security.AccessControl.FileSecurity GetAccessControl(this System.IO.FileInfo fileInfo, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            public static System.Security.AccessControl.FileSecurity GetAccessControl(this System.IO.FileStream fileStream) => throw null;
            public static void SetAccessControl(this System.IO.DirectoryInfo directoryInfo, System.Security.AccessControl.DirectorySecurity directorySecurity) => throw null;
            public static void SetAccessControl(this System.IO.FileInfo fileInfo, System.Security.AccessControl.FileSecurity fileSecurity) => throw null;
            public static void SetAccessControl(this System.IO.FileStream fileStream, System.Security.AccessControl.FileSecurity fileSecurity) => throw null;
        }
    }
    namespace Security
    {
        namespace AccessControl
        {
            public abstract class DirectoryObjectSecurity : System.Security.AccessControl.ObjectSecurity
            {
                public virtual System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                protected void AddAccessRule(System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                protected void AddAuditRule(System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                public virtual System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags, System.Guid objectType, System.Guid inheritedObjectType) => throw null;
                protected DirectoryObjectSecurity() => throw null;
                protected DirectoryObjectSecurity(System.Security.AccessControl.CommonSecurityDescriptor securityDescriptor) => throw null;
                public System.Security.AccessControl.AuthorizationRuleCollection GetAccessRules(bool includeExplicit, bool includeInherited, System.Type targetType) => throw null;
                public System.Security.AccessControl.AuthorizationRuleCollection GetAuditRules(bool includeExplicit, bool includeInherited, System.Type targetType) => throw null;
                protected override bool ModifyAccess(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AccessRule rule, out bool modified) => throw null;
                protected override bool ModifyAudit(System.Security.AccessControl.AccessControlModification modification, System.Security.AccessControl.AuditRule rule, out bool modified) => throw null;
                protected bool RemoveAccessRule(System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                protected void RemoveAccessRuleAll(System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                protected void RemoveAccessRuleSpecific(System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                protected bool RemoveAuditRule(System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                protected void RemoveAuditRuleAll(System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                protected void RemoveAuditRuleSpecific(System.Security.AccessControl.ObjectAuditRule rule) => throw null;
                protected void ResetAccessRule(System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                protected void SetAccessRule(System.Security.AccessControl.ObjectAccessRule rule) => throw null;
                protected void SetAuditRule(System.Security.AccessControl.ObjectAuditRule rule) => throw null;
            }
            public sealed class DirectorySecurity : System.Security.AccessControl.FileSystemSecurity
            {
                public DirectorySecurity() => throw null;
                public DirectorySecurity(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            }
            public sealed class FileSecurity : System.Security.AccessControl.FileSystemSecurity
            {
                public FileSecurity() => throw null;
                public FileSecurity(string fileName, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            }
            public sealed class FileSystemAccessRule : System.Security.AccessControl.AccessRule
            {
                public FileSystemAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public FileSystemAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public FileSystemAccessRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public FileSystemAccessRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.FileSystemRights FileSystemRights { get => throw null; }
            }
            public sealed class FileSystemAuditRule : System.Security.AccessControl.AuditRule
            {
                public FileSystemAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public FileSystemAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public FileSystemAuditRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public FileSystemAuditRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.FileSystemRights FileSystemRights { get => throw null; }
            }
            [System.Flags]
            public enum FileSystemRights
            {
                ListDirectory = 1,
                ReadData = 1,
                CreateFiles = 2,
                WriteData = 2,
                AppendData = 4,
                CreateDirectories = 4,
                ReadExtendedAttributes = 8,
                WriteExtendedAttributes = 16,
                ExecuteFile = 32,
                Traverse = 32,
                DeleteSubdirectoriesAndFiles = 64,
                ReadAttributes = 128,
                WriteAttributes = 256,
                Write = 278,
                Delete = 65536,
                ReadPermissions = 131072,
                Read = 131209,
                ReadAndExecute = 131241,
                Modify = 197055,
                ChangePermissions = 262144,
                TakeOwnership = 524288,
                Synchronize = 1048576,
                FullControl = 2032127,
            }
            public abstract class FileSystemSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override sealed System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void AddAuditRule(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public override sealed System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                public bool RemoveAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void RemoveAccessRuleAll(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public void ResetAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void SetAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void SetAuditRule(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                internal FileSystemSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) { }
            }
        }
    }
}
