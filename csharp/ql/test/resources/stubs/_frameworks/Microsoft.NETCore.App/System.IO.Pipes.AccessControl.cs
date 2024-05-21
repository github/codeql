// This file contains auto-generated code.
// Generated from `System.IO.Pipes.AccessControl, Version=8.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a`.
namespace System
{
    namespace IO
    {
        namespace Pipes
        {
            public static class AnonymousPipeServerStreamAcl
            {
                public static System.IO.Pipes.AnonymousPipeServerStream Create(System.IO.Pipes.PipeDirection direction, System.IO.HandleInheritability inheritability, int bufferSize, System.IO.Pipes.PipeSecurity pipeSecurity) => throw null;
            }
            public static class NamedPipeServerStreamAcl
            {
                public static System.IO.Pipes.NamedPipeServerStream Create(string pipeName, System.IO.Pipes.PipeDirection direction, int maxNumberOfServerInstances, System.IO.Pipes.PipeTransmissionMode transmissionMode, System.IO.Pipes.PipeOptions options, int inBufferSize, int outBufferSize, System.IO.Pipes.PipeSecurity pipeSecurity, System.IO.HandleInheritability inheritability = default(System.IO.HandleInheritability), System.IO.Pipes.PipeAccessRights additionalAccessRights = default(System.IO.Pipes.PipeAccessRights)) => throw null;
            }
            [System.Flags]
            public enum PipeAccessRights
            {
                ReadData = 1,
                WriteData = 2,
                CreateNewInstance = 4,
                ReadExtendedAttributes = 8,
                WriteExtendedAttributes = 16,
                ReadAttributes = 128,
                WriteAttributes = 256,
                Write = 274,
                Delete = 65536,
                ReadPermissions = 131072,
                Read = 131209,
                ReadWrite = 131483,
                ChangePermissions = 262144,
                TakeOwnership = 524288,
                Synchronize = 1048576,
                FullControl = 2032031,
                AccessSystemSecurity = 16777216,
            }
            public sealed class PipeAccessRule : System.Security.AccessControl.AccessRule
            {
                public PipeAccessRule(System.Security.Principal.IdentityReference identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public PipeAccessRule(string identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AccessControlType type) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AccessControlType)) => throw null;
                public System.IO.Pipes.PipeAccessRights PipeAccessRights { get => throw null; }
            }
            public sealed class PipeAuditRule : System.Security.AccessControl.AuditRule
            {
                public PipeAuditRule(System.Security.Principal.IdentityReference identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public PipeAuditRule(string identity, System.IO.Pipes.PipeAccessRights rights, System.Security.AccessControl.AuditFlags flags) : base(default(System.Security.Principal.IdentityReference), default(int), default(bool), default(System.Security.AccessControl.InheritanceFlags), default(System.Security.AccessControl.PropagationFlags), default(System.Security.AccessControl.AuditFlags)) => throw null;
                public System.IO.Pipes.PipeAccessRights PipeAccessRights { get => throw null; }
            }
            public static partial class PipesAclExtensions
            {
                public static System.IO.Pipes.PipeSecurity GetAccessControl(this System.IO.Pipes.PipeStream stream) => throw null;
                public static void SetAccessControl(this System.IO.Pipes.PipeStream stream, System.IO.Pipes.PipeSecurity pipeSecurity) => throw null;
            }
            public class PipeSecurity : System.Security.AccessControl.NativeObjectSecurity
            {
                public override System.Type AccessRightType { get => throw null; }
                public override System.Security.AccessControl.AccessRule AccessRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AccessControlType type) => throw null;
                public override System.Type AccessRuleType { get => throw null; }
                public void AddAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void AddAuditRule(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public override sealed System.Security.AccessControl.AuditRule AuditRuleFactory(System.Security.Principal.IdentityReference identityReference, int accessMask, bool isInherited, System.Security.AccessControl.InheritanceFlags inheritanceFlags, System.Security.AccessControl.PropagationFlags propagationFlags, System.Security.AccessControl.AuditFlags flags) => throw null;
                public override System.Type AuditRuleType { get => throw null; }
                public PipeSecurity() : base(default(bool), default(System.Security.AccessControl.ResourceType)) => throw null;
                protected void Persist(System.Runtime.InteropServices.SafeHandle handle) => throw null;
                protected void Persist(string name) => throw null;
                public bool RemoveAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void RemoveAccessRuleSpecific(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public bool RemoveAuditRule(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public void RemoveAuditRuleAll(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public void RemoveAuditRuleSpecific(System.IO.Pipes.PipeAuditRule rule) => throw null;
                public void ResetAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void SetAccessRule(System.IO.Pipes.PipeAccessRule rule) => throw null;
                public void SetAuditRule(System.IO.Pipes.PipeAuditRule rule) => throw null;
            }
        }
    }
}
