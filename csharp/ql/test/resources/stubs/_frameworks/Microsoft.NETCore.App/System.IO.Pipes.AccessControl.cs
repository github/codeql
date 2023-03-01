// This file contains auto-generated code.

namespace System
{
    namespace IO
    {
        namespace Pipes
        {
            // Generated from `System.IO.Pipes.AnonymousPipeServerStreamAcl` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class AnonymousPipeServerStreamAcl
            {
                public static System.IO.Pipes.AnonymousPipeServerStream Create(System.IO.Pipes.PipeDirection direction, System.IO.HandleInheritability inheritability, int bufferSize, System.IO.Pipes.PipeSecurity pipeSecurity) => throw null;
            }

            // Generated from `System.IO.Pipes.NamedPipeServerStreamAcl` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class NamedPipeServerStreamAcl
            {
                public static System.IO.Pipes.NamedPipeServerStream Create(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode, System.IO.Pipes.PipeOptions options, int inBufferSize, int outBufferSize, System.IO.Pipes.PipeSecurity pipeSecurity, System.IO.HandleInheritability inheritability = default(System.IO.HandleInheritability), System.IO.Pipes.PipeAccessRights additionalAccessRights = default(System.IO.Pipes.PipeAccessRights)) => throw null;
            }

            // Generated from `System.IO.Pipes.PipeAccessRights` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            [System.Flags]
            public enum PipeAccessRights : int
            {
                AccessSystemSecurity = 16777216,
                ChangePermissions = 262144,
                CreateNewInstance = 4,
                Delete = 65536,
                FullControl = 2032031,
                Read = 131209,
                ReadAttributes = 128,
                ReadData = 1,
                ReadExtendedAttributes = 8,
                ReadPermissions = 131072,
                ReadWrite = 131483,
                Synchronize = 1048576,
                TakeOwnership = 524288,
                Write = 274,
                WriteAttributes = 256,
                WriteData = 2,
                WriteExtendedAttributes = 16,
            }

            // Generated from `System.IO.Pipes.PipeAccessRule` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PipeAccessRule : System.Security.AccessControl.AccessRule
            {
                public System.IO.Pipes.PipeAccessRights PipeAccessRights { get => throw null; }
                public PipeAccessRule(System.Security.Principal.IdentityReference identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public PipeAccessRule(string identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
            }

            // Generated from `System.IO.Pipes.PipeAuditRule` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PipeAuditRule : System.Security.AccessControl.AuditRule
            {
                public System.IO.Pipes.PipeAccessRights PipeAccessRights { get => throw null; }
                public PipeAuditRule(System.Security.Principal.IdentityReference identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public PipeAuditRule(string identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
            }

            // Generated from `System.IO.Pipes.PipeSecurity` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public class PipeSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void AddAuditRule(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public override System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                protected internal void Persist(System.Runtime.InteropServices.SafeHandle handle) => throw null;
                protected internal void Persist(string name) => throw null;
                public PipeSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                public bool RemoveAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public void ResetAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void SetAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void SetAuditRule(System.IO.Pipes.PipeAuditRule rule) => throw null;
            }

            // Generated from `System.IO.Pipes.PipesAclExtensions` in `System.IO.Pipes.AccessControl, Version=7.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`
            public static class PipesAclExtensions
            {
                public static System.IO.Pipes.PipeSecurity GetAccessControl(this System.IO.Pipes.PipeStream stream) => throw null;
                public static void SetAccessControl(this System.IO.Pipes.PipeStream stream, System.IO.Pipes.PipeSecurity pipeSecurity) => throw null;
            }

        }
    }
}
