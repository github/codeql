// This file contains auto-generated code.
// Generated from `System.Threading.AccessControl, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace Security
    {
        namespace AccessControl
        {
            public sealed class EventWaitHandleAccessRule : System.Security.AccessControl.AccessRule
            {
                public EventWaitHandleAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.EventWaitHandleRights eventRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public EventWaitHandleAccessRule(string identity, System.Security.AccessControl.EventWaitHandleRights eventRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.EventWaitHandleRights EventWaitHandleRights { get => throw null; }
            }
            public sealed class EventWaitHandleAuditRule : System.Security.AccessControl.AuditRule
            {
                public EventWaitHandleAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.EventWaitHandleRights eventRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.EventWaitHandleRights EventWaitHandleRights { get => throw null; }
            }
            [System.Flags]
            public enum EventWaitHandleRights
            {
                Modify = 2,
                Delete = 65536,
                ReadPermissions = 131072,
                ChangePermissions = 262144,
                TakeOwnership = 524288,
                Synchronize = 1048576,
                FullControl = 2031619,
            }
            public sealed class EventWaitHandleSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.Security.AccessControl.EventWaitHandleAccessRule rule) => throw null;
                public void AddAuditRule(System.Security.AccessControl.EventWaitHandleAuditRule rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                public EventWaitHandleSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public bool RemoveAccessRule(System.Security.AccessControl.EventWaitHandleAccessRule rule) => throw null;
                public void RemoveAccessRuleAll(System.Security.AccessControl.EventWaitHandleAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.Security.AccessControl.EventWaitHandleAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.Security.AccessControl.EventWaitHandleAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.Security.AccessControl.EventWaitHandleAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.Security.AccessControl.EventWaitHandleAuditRule rule) => throw null;
                public void ResetAccessRule(System.Security.AccessControl.EventWaitHandleAccessRule rule) => throw null;
                public void SetAccessRule(System.Security.AccessControl.EventWaitHandleAccessRule rule) => throw null;
                public void SetAuditRule(System.Security.AccessControl.EventWaitHandleAuditRule rule) => throw null;
            }
            public sealed class MutexAccessRule : System.Security.AccessControl.AccessRule
            {
                public MutexAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.MutexRights eventRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public MutexAccessRule(string identity, System.Security.AccessControl.MutexRights eventRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.MutexRights MutexRights { get => throw null; }
            }
            public sealed class MutexAuditRule : System.Security.AccessControl.AuditRule
            {
                public MutexAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.MutexRights eventRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.MutexRights MutexRights { get => throw null; }
            }
            [System.Flags]
            public enum MutexRights
            {
                Modify = 1,
                Delete = 65536,
                ReadPermissions = 131072,
                ChangePermissions = 262144,
                TakeOwnership = 524288,
                Synchronize = 1048576,
                FullControl = 2031617,
            }
            public sealed class MutexSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.Security.AccessControl.MutexAccessRule rule) => throw null;
                public void AddAuditRule(System.Security.AccessControl.MutexAuditRule rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                public MutexSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public MutexSecurity(string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public bool RemoveAccessRule(System.Security.AccessControl.MutexAccessRule rule) => throw null;
                public void RemoveAccessRuleAll(System.Security.AccessControl.MutexAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.Security.AccessControl.MutexAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.Security.AccessControl.MutexAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.Security.AccessControl.MutexAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.Security.AccessControl.MutexAuditRule rule) => throw null;
                public void ResetAccessRule(System.Security.AccessControl.MutexAccessRule rule) => throw null;
                public void SetAccessRule(System.Security.AccessControl.MutexAccessRule rule) => throw null;
                public void SetAuditRule(System.Security.AccessControl.MutexAuditRule rule) => throw null;
            }
            public sealed class SemaphoreAccessRule : System.Security.AccessControl.AccessRule
            {
                public SemaphoreAccessRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.SemaphoreRights eventRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public SemaphoreAccessRule(string identity, System.Security.AccessControl.SemaphoreRights eventRights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.Security.AccessControl.SemaphoreRights SemaphoreRights { get => throw null; }
            }
            public sealed class SemaphoreAuditRule : System.Security.AccessControl.AuditRule
            {
                public SemaphoreAuditRule(System.Security.Principal.IdentityReference identity, System.Security.AccessControl.SemaphoreRights eventRights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.Security.AccessControl.SemaphoreRights SemaphoreRights { get => throw null; }
            }
            [System.Flags]
            public enum SemaphoreRights
            {
                Modify = 2,
                Delete = 65536,
                ReadPermissions = 131072,
                ChangePermissions = 262144,
                TakeOwnership = 524288,
                Synchronize = 1048576,
                FullControl = 2031619,
            }
            public sealed class SemaphoreSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.Security.AccessControl.SemaphoreAccessRule rule) => throw null;
                public void AddAuditRule(System.Security.AccessControl.SemaphoreAuditRule rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                public SemaphoreSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public SemaphoreSecurity(string name, System.Security.AccessControl.AccessControlSections includeSections) : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public bool RemoveAccessRule(System.Security.AccessControl.SemaphoreAccessRule rule) => throw null;
                public void RemoveAccessRuleAll(System.Security.AccessControl.SemaphoreAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.Security.AccessControl.SemaphoreAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.Security.AccessControl.SemaphoreAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.Security.AccessControl.SemaphoreAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.Security.AccessControl.SemaphoreAuditRule rule) => throw null;
                public void ResetAccessRule(System.Security.AccessControl.SemaphoreAccessRule rule) => throw null;
                public void SetAccessRule(System.Security.AccessControl.SemaphoreAccessRule rule) => throw null;
                public void SetAuditRule(System.Security.AccessControl.SemaphoreAuditRule rule) => throw null;
            }
        }
    }
    namespace Threading
    {
        public static class EventWaitHandleAcl
        {
            public static System.Threading.EventWaitHandle Create(bool initialState, System.Threading.EventResetMode mode, string name, out bool createdNew, System.Security.AccessControl.EventWaitHandleSecurity eventSecurity) => throw null;
            public static System.Threading.EventWaitHandle OpenExisting(string name, System.Security.AccessControl.EventWaitHandleRights rights) => throw null;
            public static bool TryOpenExisting(string name, System.Security.AccessControl.EventWaitHandleRights rights, out System.Threading.EventWaitHandle result) => throw null;
        }
        public static class MutexAcl
        {
            public static System.Threading.Mutex Create(bool initiallyOwned, string name, out bool createdNew, System.Security.AccessControl.MutexSecurity mutexSecurity) => throw null;
            public static System.Threading.Mutex OpenExisting(string name, System.Security.AccessControl.MutexRights rights) => throw null;
            public static bool TryOpenExisting(string name, System.Security.AccessControl.MutexRights rights, out System.Threading.Mutex result) => throw null;
        }
        public static class SemaphoreAcl
        {
            public static System.Threading.Semaphore Create(int initialCount, int maximumCount, string name, out bool createdNew, System.Security.AccessControl.SemaphoreSecurity semaphoreSecurity) => throw null;
            public static System.Threading.Semaphore OpenExisting(string name, System.Security.AccessControl.SemaphoreRights rights) => throw null;
            public static bool TryOpenExisting(string name, System.Security.AccessControl.SemaphoreRights rights, out System.Threading.Semaphore result) => throw null;
        }
        public static partial class ThreadingAclExtensions
        {
            public static System.Security.AccessControl.EventWaitHandleSecurity GetAccessControl(this System.Threading.EventWaitHandle handle) => throw null;
            public static System.Security.AccessControl.MutexSecurity GetAccessControl(this System.Threading.Mutex mutex) => throw null;
            public static System.Security.AccessControl.SemaphoreSecurity GetAccessControl(this System.Threading.Semaphore semaphore) => throw null;
            public static void SetAccessControl(this System.Threading.EventWaitHandle handle, System.Security.AccessControl.EventWaitHandleSecurity eventSecurity) => throw null;
            public static void SetAccessControl(this System.Threading.Mutex mutex, System.Security.AccessControl.MutexSecurity mutexSecurity) => throw null;
            public static void SetAccessControl(this System.Threading.Semaphore semaphore, System.Security.AccessControl.SemaphoreSecurity semaphoreSecurity) => throw null;
        }
    }
}
