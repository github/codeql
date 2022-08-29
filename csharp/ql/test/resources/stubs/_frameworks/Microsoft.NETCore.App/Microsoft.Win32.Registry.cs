// This file contains auto-generated code.

namespace Microsoft
{
    namespace Win32
    {
        // Generated from `Microsoft.Win32.Registry` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public static class Registry
        {
            public static Microsoft.Win32.RegistryKey ClassesRoot;
            public static Microsoft.Win32.RegistryKey CurrentConfig;
            public static Microsoft.Win32.RegistryKey CurrentUser;
            public static object GetValue(string keyName, string valueName, object defaultValue) => throw null;
            public static Microsoft.Win32.RegistryKey LocalMachine;
            public static Microsoft.Win32.RegistryKey PerformanceData;
            public static void SetValue(string keyName, string valueName, object value) => throw null;
            public static void SetValue(string keyName, string valueName, object value, Microsoft.Win32.RegistryValueKind valueKind) => throw null;
            public static Microsoft.Win32.RegistryKey Users;
        }

        // Generated from `Microsoft.Win32.RegistryHive` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum RegistryHive : int
        {
            ClassesRoot = -2147483648,
            CurrentConfig = -2147483643,
            CurrentUser = -2147483647,
            LocalMachine = -2147483646,
            PerformanceData = -2147483644,
            Users = -2147483645,
        }

        // Generated from `Microsoft.Win32.RegistryKey` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public class RegistryKey : System.MarshalByRefObject, System.IDisposable
        {
            public void Close() => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey) => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey, Microsoft.Win32.RegistryKeyPermissionCheck permissionCheck) => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey, Microsoft.Win32.RegistryKeyPermissionCheck permissionCheck, Microsoft.Win32.RegistryOptions registryOptions) => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey, Microsoft.Win32.RegistryKeyPermissionCheck permissionCheck, Microsoft.Win32.RegistryOptions registryOptions, System.Security.AccessControl.RegistrySecurity registrySecurity) => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey, Microsoft.Win32.RegistryKeyPermissionCheck permissionCheck, System.Security.AccessControl.RegistrySecurity registrySecurity) => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey, bool writable) => throw null;
            public Microsoft.Win32.RegistryKey CreateSubKey(string subkey, bool writable, Microsoft.Win32.RegistryOptions options) => throw null;
            public void DeleteSubKey(string subkey) => throw null;
            public void DeleteSubKey(string subkey, bool throwOnMissingSubKey) => throw null;
            public void DeleteSubKeyTree(string subkey) => throw null;
            public void DeleteSubKeyTree(string subkey, bool throwOnMissingSubKey) => throw null;
            public void DeleteValue(string name) => throw null;
            public void DeleteValue(string name, bool throwOnMissingValue) => throw null;
            public void Dispose() => throw null;
            public void Flush() => throw null;
            public static Microsoft.Win32.RegistryKey FromHandle(Microsoft.Win32.SafeHandles.SafeRegistryHandle handle) => throw null;
            public static Microsoft.Win32.RegistryKey FromHandle(Microsoft.Win32.SafeHandles.SafeRegistryHandle handle, Microsoft.Win32.RegistryView view) => throw null;
            public System.Security.AccessControl.RegistrySecurity GetAccessControl() => throw null;
            public System.Security.AccessControl.RegistrySecurity GetAccessControl(System.Security.AccessControl.AccessControlSections includeSections) => throw null;
            public string[] GetSubKeyNames() => throw null;
            public object GetValue(string name) => throw null;
            public object GetValue(string name, object defaultValue) => throw null;
            public object GetValue(string name, object defaultValue, Microsoft.Win32.RegistryValueOptions options) => throw null;
            public Microsoft.Win32.RegistryValueKind GetValueKind(string name) => throw null;
            public string[] GetValueNames() => throw null;
            public Microsoft.Win32.SafeHandles.SafeRegistryHandle Handle { get => throw null; }
            public string Name { get => throw null; }
            public static Microsoft.Win32.RegistryKey OpenBaseKey(Microsoft.Win32.RegistryHive hKey, Microsoft.Win32.RegistryView view) => throw null;
            public static Microsoft.Win32.RegistryKey OpenRemoteBaseKey(Microsoft.Win32.RegistryHive hKey, string machineName) => throw null;
            public static Microsoft.Win32.RegistryKey OpenRemoteBaseKey(Microsoft.Win32.RegistryHive hKey, string machineName, Microsoft.Win32.RegistryView view) => throw null;
            public Microsoft.Win32.RegistryKey OpenSubKey(string name) => throw null;
            public Microsoft.Win32.RegistryKey OpenSubKey(string name, Microsoft.Win32.RegistryKeyPermissionCheck permissionCheck) => throw null;
            public Microsoft.Win32.RegistryKey OpenSubKey(string name, Microsoft.Win32.RegistryKeyPermissionCheck permissionCheck, System.Security.AccessControl.RegistryRights rights) => throw null;
            public Microsoft.Win32.RegistryKey OpenSubKey(string name, System.Security.AccessControl.RegistryRights rights) => throw null;
            public Microsoft.Win32.RegistryKey OpenSubKey(string name, bool writable) => throw null;
            public void SetAccessControl(System.Security.AccessControl.RegistrySecurity registrySecurity) => throw null;
            public void SetValue(string name, object value) => throw null;
            public void SetValue(string name, object value, Microsoft.Win32.RegistryValueKind valueKind) => throw null;
            public int SubKeyCount { get => throw null; }
            public override string ToString() => throw null;
            public int ValueCount { get => throw null; }
            public Microsoft.Win32.RegistryView View { get => throw null; }
        }

        // Generated from `Microsoft.Win32.RegistryKeyPermissionCheck` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum RegistryKeyPermissionCheck : int
        {
            Default = 0,
            ReadSubTree = 1,
            ReadWriteSubTree = 2,
        }

        // Generated from `Microsoft.Win32.RegistryOptions` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum RegistryOptions : int
        {
            None = 0,
            Volatile = 1,
        }

        // Generated from `Microsoft.Win32.RegistryValueKind` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum RegistryValueKind : int
        {
            Binary = 3,
            DWord = 4,
            ExpandString = 2,
            MultiString = 7,
            None = -1,
            QWord = 11,
            String = 1,
            Unknown = 0,
        }

        // Generated from `Microsoft.Win32.RegistryValueOptions` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        [System.Flags]
        public enum RegistryValueOptions : int
        {
            DoNotExpandEnvironmentNames = 1,
            None = 0,
        }

        // Generated from `Microsoft.Win32.RegistryView` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
        public enum RegistryView : int
        {
            Default = 0,
            Registry32 = 512,
            Registry64 = 256,
        }

        namespace SafeHandles
        {
            // Generated from `Microsoft.Win32.SafeHandles.SafeRegistryHandle` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class SafeRegistryHandle : Microsoft.Win32.SafeHandles.SafeHandleZeroOrMinusOneIsInvalid
            {
                protected override bool ReleaseHandle() => throw null;
                public SafeRegistryHandle() : base(default(bool)) => throw null;
                public SafeRegistryHandle(System.IntPtr preexistingHandle, bool ownsHandle) : base(default(bool)) => throw null;
            }

        }
    }
}
namespace System
{
    namespace Security
    {
        namespace AccessControl
        {
            // Generated from `System.Security.AccessControl.RegistryAccessRule` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RegistryAccessRule : System.Security.AccessControl.AccessRule
            {
                public RegistryAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.RegistryRights registryRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public RegistryAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.RegistryRights registryRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public RegistryAccessRule(string identity, System.Security.AccessControl.RegistryRights registryRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public RegistryAccessRule(string identity, System.Security.AccessControl.RegistryRights registryRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.RegistryRights RegistryRights { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.RegistryAuditRule` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RegistryAuditRule : System.Security.AccessControl.AuditRule
            {
                public RegistryAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.RegistryRights registryRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public RegistryAuditRule(string identity, System.Security.AccessControl.RegistryRights registryRights, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.RegistryRights RegistryRights { get => throw null; }
            }

            // Generated from `System.Security.AccessControl.RegistryRights` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum RegistryRights : int
            {
                ChangePermissions = 262144,
                CreateLink = 32,
                CreateSubKey = 4,
                Delete = 65536,
                EnumerateSubKeys = 8,
                ExecuteKey = 131097,
                FullControl = 983103,
                Notify = 16,
                QueryValues = 1,
                ReadKey = 131097,
                ReadPermissions = 131072,
                SetValue = 2,
                TakeOwnership = 524288,
                WriteKey = 131078,
            }

            // Generated from `System.Security.AccessControl.RegistrySecurity` in `Microsoft.Win32.Registry, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class RegistrySecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.Security.AccessControl.RegistryAccessRule rule) => throw null;
                public void AddAuditRule(System.Security.AccessControl.RegistryAuditRule rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                public RegistrySecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public bool RemoveAccessRule(System.Security.AccessControl.RegistryAccessRule rule) => throw null;
                public void RemoveAccessRuleAll(System.Security.AccessControl.RegistryAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.Security.AccessControl.RegistryAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.Security.AccessControl.RegistryAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.Security.AccessControl.RegistryAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.Security.AccessControl.RegistryAuditRule rule) => throw null;
                public void ResetAccessRule(System.Security.AccessControl.RegistryAccessRule rule) => throw null;
                public void SetAccessRule(System.Security.AccessControl.RegistryAccessRule rule) => throw null;
                public void SetAuditRule(System.Security.AccessControl.RegistryAuditRule rule) => throw null;
            }

        }
    }
}
