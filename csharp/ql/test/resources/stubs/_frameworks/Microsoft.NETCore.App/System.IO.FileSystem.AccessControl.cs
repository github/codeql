// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        // Generated from `System.IO.FileSystemAclExtensions` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class FileSystemAclExtensions
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
            // Generated from `System.Security.AccessControl.DirectoryObjectSecurity` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
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

            // Generated from `System.Security.AccessControl.DirectorySecurity` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class DirectorySecurity : System.Security.AccessControl.FileSystemSecurity
            {
                public DirectorySecurity() => throw null;
                public DirectorySecurity(string name, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            }

            // Generated from `System.Security.AccessControl.FileSecurity` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FileSecurity : System.Security.AccessControl.FileSystemSecurity
            {
                public FileSecurity() => throw null;
                public FileSecurity(string fileName, System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            }

            // Generated from `System.Security.AccessControl.FileSystemAccessRule` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FileSystemAccessRule : System.Security.AccessControl.AccessRule
            {
                public FileSystemAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public FileSystemAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public FileSystemAccessRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public FileSystemAccessRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.FileSystemRights FileSystemRights { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.FileSystemAuditRule` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class FileSystemAuditRule : System.Security.AccessControl.AuditRule
            {
                public FileSystemAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public FileSystemAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public FileSystemAuditRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public FileSystemAuditRule(string identity, System.Security.AccessControl.FileSystemRights fileSystemRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.FileSystemRights FileSystemRights { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.FileSystemRights` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum FileSystemRights : int
            {
                AppendData = 4,
                ChangePermissions = 262144,
                CreateDirectories = 4,
                CreateFiles = 2,
                Delete = 65536,
                DeleteSubdirectoriesAndFiles = 64,
                ExecuteFile = 32,
                FullControl = 2032127,
                ListDirectory = 1,
                Modify = 197055,
                Read = 131209,
                ReadAndExecute = 131241,
                ReadAttributes = 128,
                ReadData = 1,
                ReadExtendedAttributes = 8,
                ReadPermissions = 131072,
                Synchronize = 1048576,
                TakeOwnership = 524288,
                Traverse = 32,
                Write = 278,
                WriteAttributes = 256,
                WriteData = 2,
                WriteExtendedAttributes = 16,
            }

            // Generated from `System.Security.AccessControl.FileSystemSecurity` in `System.IO.FileSystem.AccessControl, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public abstract class FileSystemSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void AddAuditRule(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                internal FileSystemSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public bool RemoveAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void RemoveAccessRuleAll(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
                public void ResetAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void SetAccessRule(System.Security.AccessControl.FileSystemAccessRule rule) => throw null;
                public void SetAuditRule(System.Security.AccessControl.FileSystemAuditRule rule) => throw null;
            }

        }
    }
}
