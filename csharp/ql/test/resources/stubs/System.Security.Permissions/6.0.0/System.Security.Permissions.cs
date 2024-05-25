// This file contains auto-generated code.
// Generated from `System.Security.Permissions, Version=6.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`.
namespace System
{
    public sealed class ApplicationIdentity : System.Runtime.Serialization.ISerializable
    {
        public string CodeBase { get => throw null; }
        public ApplicationIdentity(string applicationIdentityFullName) => throw null;
        public string FullName { get => throw null; }
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string ToString() => throw null;
    }
    namespace Configuration
    {
        public sealed class ConfigurationPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public override System.Security.IPermission Copy() => throw null;
            public ConfigurationPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767, AllowMultiple = true, Inherited = false)]
        public sealed class ConfigurationPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public ConfigurationPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
        }
    }
    namespace Data
    {
        namespace Common
        {
            public abstract class DBDataPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public virtual void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public bool AllowBlankPassword { get => throw null; set { } }
                protected void Clear() => throw null;
                public override System.Security.IPermission Copy() => throw null;
                protected virtual System.Data.Common.DBDataPermission CreateInstance() => throw null;
                protected DBDataPermission() => throw null;
                protected DBDataPermission(System.Data.Common.DBDataPermission permission) => throw null;
                protected DBDataPermission(System.Data.Common.DBDataPermissionAttribute permissionAttribute) => throw null;
                protected DBDataPermission(System.Security.Permissions.PermissionState state) => throw null;
                protected DBDataPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public abstract class DBDataPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool AllowBlankPassword { get => throw null; set { } }
                public string ConnectionString { get => throw null; set { } }
                protected DBDataPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Data.KeyRestrictionBehavior KeyRestrictionBehavior { get => throw null; set { } }
                public string KeyRestrictions { get => throw null; set { } }
                public bool ShouldSerializeConnectionString() => throw null;
                public bool ShouldSerializeKeyRestrictions() => throw null;
            }
        }
        namespace Odbc
        {
            public sealed class OdbcPermission : System.Data.Common.DBDataPermission
            {
                public override void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public OdbcPermission() => throw null;
                public OdbcPermission(System.Security.Permissions.PermissionState state) => throw null;
                public OdbcPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class OdbcPermissionAttribute : System.Data.Common.DBDataPermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public OdbcPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
        }
        namespace OleDb
        {
            public sealed class OleDbPermission : System.Data.Common.DBDataPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public OleDbPermission() => throw null;
                public OleDbPermission(System.Security.Permissions.PermissionState state) => throw null;
                public OleDbPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
                public string Provider { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class OleDbPermissionAttribute : System.Data.Common.DBDataPermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public OleDbPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Provider { get => throw null; set { } }
            }
        }
        namespace OracleClient
        {
            public sealed class OraclePermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public bool AllowBlankPassword { get => throw null; set { } }
                public override System.Security.IPermission Copy() => throw null;
                public OraclePermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class OraclePermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool AllowBlankPassword { get => throw null; set { } }
                public string ConnectionString { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public OraclePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Data.KeyRestrictionBehavior KeyRestrictionBehavior { get => throw null; set { } }
                public string KeyRestrictions { get => throw null; set { } }
                public bool ShouldSerializeConnectionString() => throw null;
                public bool ShouldSerializeKeyRestrictions() => throw null;
            }
        }
        namespace SqlClient
        {
            public sealed class SqlClientPermission : System.Data.Common.DBDataPermission
            {
                public override void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public SqlClientPermission() => throw null;
                public SqlClientPermission(System.Security.Permissions.PermissionState state) => throw null;
                public SqlClientPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class SqlClientPermissionAttribute : System.Data.Common.DBDataPermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public SqlClientPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
        }
    }
    namespace Diagnostics
    {
        public sealed class EventLogPermission : System.Security.Permissions.ResourcePermissionBase
        {
            public EventLogPermission() => throw null;
            public EventLogPermission(System.Diagnostics.EventLogPermissionAccess permissionAccess, string machineName) => throw null;
            public EventLogPermission(System.Diagnostics.EventLogPermissionEntry[] permissionAccessEntries) => throw null;
            public EventLogPermission(System.Security.Permissions.PermissionState state) => throw null;
            public System.Diagnostics.EventLogPermissionEntryCollection PermissionEntries { get => throw null; }
        }
        [System.Flags]
        public enum EventLogPermissionAccess
        {
            Administer = 48,
            Audit = 10,
            Browse = 2,
            Instrument = 6,
            None = 0,
            Write = 16,
        }
        [System.AttributeUsage((System.AttributeTargets)621, AllowMultiple = true, Inherited = false)]
        public class EventLogPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public EventLogPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string MachineName { get => throw null; set { } }
            public System.Diagnostics.EventLogPermissionAccess PermissionAccess { get => throw null; set { } }
        }
        public class EventLogPermissionEntry
        {
            public EventLogPermissionEntry(System.Diagnostics.EventLogPermissionAccess permissionAccess, string machineName) => throw null;
            public string MachineName { get => throw null; }
            public System.Diagnostics.EventLogPermissionAccess PermissionAccess { get => throw null; }
        }
        public class EventLogPermissionEntryCollection : System.Collections.CollectionBase
        {
            public int Add(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public void AddRange(System.Diagnostics.EventLogPermissionEntryCollection value) => throw null;
            public void AddRange(System.Diagnostics.EventLogPermissionEntry[] value) => throw null;
            public bool Contains(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public void CopyTo(System.Diagnostics.EventLogPermissionEntry[] array, int index) => throw null;
            public int IndexOf(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public void Insert(int index, System.Diagnostics.EventLogPermissionEntry value) => throw null;
            protected override void OnClear() => throw null;
            protected override void OnInsert(int index, object value) => throw null;
            protected override void OnRemove(int index, object value) => throw null;
            protected override void OnSet(int index, object oldValue, object newValue) => throw null;
            public void Remove(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public System.Diagnostics.EventLogPermissionEntry this[int index] { get => throw null; set { } }
        }
        public sealed class PerformanceCounterPermission : System.Security.Permissions.ResourcePermissionBase
        {
            public PerformanceCounterPermission() => throw null;
            public PerformanceCounterPermission(System.Diagnostics.PerformanceCounterPermissionAccess permissionAccess, string machineName, string categoryName) => throw null;
            public PerformanceCounterPermission(System.Diagnostics.PerformanceCounterPermissionEntry[] permissionAccessEntries) => throw null;
            public PerformanceCounterPermission(System.Security.Permissions.PermissionState state) => throw null;
            public System.Diagnostics.PerformanceCounterPermissionEntryCollection PermissionEntries { get => throw null; }
        }
        [System.Flags]
        public enum PerformanceCounterPermissionAccess
        {
            Administer = 7,
            Browse = 1,
            Instrument = 3,
            None = 0,
            Read = 1,
            Write = 2,
        }
        [System.AttributeUsage((System.AttributeTargets)621, AllowMultiple = true, Inherited = false)]
        public class PerformanceCounterPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public string CategoryName { get => throw null; set { } }
            public override System.Security.IPermission CreatePermission() => throw null;
            public PerformanceCounterPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string MachineName { get => throw null; set { } }
            public System.Diagnostics.PerformanceCounterPermissionAccess PermissionAccess { get => throw null; set { } }
        }
        public class PerformanceCounterPermissionEntry
        {
            public string CategoryName { get => throw null; }
            public PerformanceCounterPermissionEntry(System.Diagnostics.PerformanceCounterPermissionAccess permissionAccess, string machineName, string categoryName) => throw null;
            public string MachineName { get => throw null; }
            public System.Diagnostics.PerformanceCounterPermissionAccess PermissionAccess { get => throw null; }
        }
        public class PerformanceCounterPermissionEntryCollection : System.Collections.CollectionBase
        {
            public int Add(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public void AddRange(System.Diagnostics.PerformanceCounterPermissionEntryCollection value) => throw null;
            public void AddRange(System.Diagnostics.PerformanceCounterPermissionEntry[] value) => throw null;
            public bool Contains(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public void CopyTo(System.Diagnostics.PerformanceCounterPermissionEntry[] array, int index) => throw null;
            public int IndexOf(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public void Insert(int index, System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            protected override void OnClear() => throw null;
            protected override void OnInsert(int index, object value) => throw null;
            protected override void OnRemove(int index, object value) => throw null;
            protected override void OnSet(int index, object oldValue, object newValue) => throw null;
            public void Remove(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public System.Diagnostics.PerformanceCounterPermissionEntry this[int index] { get => throw null; set { } }
        }
    }
    namespace Drawing
    {
        namespace Printing
        {
            public sealed class PrintingPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public PrintingPermission(System.Drawing.Printing.PrintingPermissionLevel printingLevel) => throw null;
                public PrintingPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement element) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public System.Drawing.Printing.PrintingPermissionLevel Level { get => throw null; set { } }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)32767, AllowMultiple = true)]
            public sealed class PrintingPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public PrintingPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Drawing.Printing.PrintingPermissionLevel Level { get => throw null; set { } }
            }
            public enum PrintingPermissionLevel
            {
                AllPrinting = 3,
                DefaultPrinting = 2,
                NoPrinting = 0,
                SafePrinting = 1,
            }
        }
    }
    namespace Net
    {
        public sealed class DnsPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public override System.Security.IPermission Copy() => throw null;
            public DnsPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
        public sealed class DnsPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public DnsPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
        }
        public class EndpointPermission
        {
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Hostname { get => throw null; }
            public int Port { get => throw null; }
            public System.Net.TransportType Transport { get => throw null; }
        }
        namespace Mail
        {
            public enum SmtpAccess
            {
                Connect = 1,
                ConnectToUnrestrictedPort = 2,
                None = 0,
            }
            public sealed class SmtpPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Net.Mail.SmtpAccess Access { get => throw null; }
                public void AddPermission(System.Net.Mail.SmtpAccess access) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public SmtpPermission(bool unrestricted) => throw null;
                public SmtpPermission(System.Net.Mail.SmtpAccess access) => throw null;
                public SmtpPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class SmtpPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string Access { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public SmtpPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
        }
        [System.Flags]
        public enum NetworkAccess
        {
            Accept = 128,
            Connect = 64,
        }
        namespace NetworkInformation
        {
            [System.Flags]
            public enum NetworkInformationAccess
            {
                None = 0,
                Read = 1,
                Ping = 4,
            }
            public sealed class NetworkInformationPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Net.NetworkInformation.NetworkInformationAccess Access { get => throw null; }
                public void AddPermission(System.Net.NetworkInformation.NetworkInformationAccess access) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public NetworkInformationPermission(System.Security.Permissions.PermissionState state) => throw null;
                public NetworkInformationPermission(System.Net.NetworkInformation.NetworkInformationAccess access) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class NetworkInformationPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string Access { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public NetworkInformationPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
        }
        namespace PeerToPeer
        {
            namespace Collaboration
            {
                public sealed class PeerCollaborationPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
                {
                    public override System.Security.IPermission Copy() => throw null;
                    public PeerCollaborationPermission(System.Security.Permissions.PermissionState state) => throw null;
                    public override void FromXml(System.Security.SecurityElement e) => throw null;
                    public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                    public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                    public bool IsUnrestricted() => throw null;
                    public override System.Security.SecurityElement ToXml() => throw null;
                    public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
                public sealed class PeerCollaborationPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
                {
                    public override System.Security.IPermission CreatePermission() => throw null;
                    public PeerCollaborationPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                }
            }
            public sealed class PnrpPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public PnrpPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement e) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class PnrpPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public PnrpPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
            public enum PnrpScope
            {
                All = 0,
                Global = 1,
                LinkLocal = 3,
                SiteLocal = 2,
            }
        }
        public sealed class SocketPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public System.Collections.IEnumerator AcceptList { get => throw null; }
            public void AddPermission(System.Net.NetworkAccess access, System.Net.TransportType transport, string hostName, int portNumber) => throw null;
            public const int AllPorts = -1;
            public System.Collections.IEnumerator ConnectList { get => throw null; }
            public override System.Security.IPermission Copy() => throw null;
            public SocketPermission(System.Net.NetworkAccess access, System.Net.TransportType transport, string hostName, int portNumber) => throw null;
            public SocketPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
        public sealed class SocketPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public string Access { get => throw null; set { } }
            public override System.Security.IPermission CreatePermission() => throw null;
            public SocketPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string Host { get => throw null; set { } }
            public string Port { get => throw null; set { } }
            public string Transport { get => throw null; set { } }
        }
        public enum TransportType
        {
            All = 3,
            Connectionless = 1,
            ConnectionOriented = 2,
            Tcp = 2,
            Udp = 1,
        }
        public sealed class WebPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public System.Collections.IEnumerator AcceptList { get => throw null; }
            public void AddPermission(System.Net.NetworkAccess access, string uriString) => throw null;
            public void AddPermission(System.Net.NetworkAccess access, System.Text.RegularExpressions.Regex uriRegex) => throw null;
            public System.Collections.IEnumerator ConnectList { get => throw null; }
            public override System.Security.IPermission Copy() => throw null;
            public WebPermission() => throw null;
            public WebPermission(System.Net.NetworkAccess access, string uriString) => throw null;
            public WebPermission(System.Net.NetworkAccess access, System.Text.RegularExpressions.Regex uriRegex) => throw null;
            public WebPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
        public sealed class WebPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public string Accept { get => throw null; set { } }
            public string AcceptPattern { get => throw null; set { } }
            public string Connect { get => throw null; set { } }
            public string ConnectPattern { get => throw null; set { } }
            public override System.Security.IPermission CreatePermission() => throw null;
            public WebPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
        }
    }
    namespace Security
    {
        public abstract class CodeAccessPermission : System.Security.IPermission, System.Security.ISecurityEncodable, System.Security.IStackWalk
        {
            public void Assert() => throw null;
            public abstract System.Security.IPermission Copy();
            protected CodeAccessPermission() => throw null;
            public void Demand() => throw null;
            public void Deny() => throw null;
            public override bool Equals(object obj) => throw null;
            public abstract void FromXml(System.Security.SecurityElement elem);
            public override int GetHashCode() => throw null;
            public abstract System.Security.IPermission Intersect(System.Security.IPermission target);
            public abstract bool IsSubsetOf(System.Security.IPermission target);
            public void PermitOnly() => throw null;
            public static void RevertAll() => throw null;
            public static void RevertAssert() => throw null;
            public static void RevertDeny() => throw null;
            public static void RevertPermitOnly() => throw null;
            public override string ToString() => throw null;
            public abstract System.Security.SecurityElement ToXml();
            public virtual System.Security.IPermission Union(System.Security.IPermission other) => throw null;
        }
        public class HostProtectionException : System.SystemException
        {
            public HostProtectionException() => throw null;
            public HostProtectionException(string message) => throw null;
            public HostProtectionException(string message, System.Exception e) => throw null;
            public HostProtectionException(string message, System.Security.Permissions.HostProtectionResource protectedResources, System.Security.Permissions.HostProtectionResource demandedResources) => throw null;
            protected HostProtectionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Security.Permissions.HostProtectionResource DemandedResources { get => throw null; }
            public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Security.Permissions.HostProtectionResource ProtectedResources { get => throw null; }
            public override string ToString() => throw null;
        }
        public class HostSecurityManager
        {
            public HostSecurityManager() => throw null;
            public virtual System.Security.Policy.ApplicationTrust DetermineApplicationTrust(System.Security.Policy.Evidence applicationEvidence, System.Security.Policy.Evidence activatorEvidence, System.Security.Policy.TrustManagerContext context) => throw null;
            public virtual System.Security.Policy.PolicyLevel DomainPolicy { get => throw null; }
            public virtual System.Security.HostSecurityManagerOptions Flags { get => throw null; }
            public virtual System.Security.Policy.EvidenceBase GenerateAppDomainEvidence(System.Type evidenceType) => throw null;
            public virtual System.Security.Policy.EvidenceBase GenerateAssemblyEvidence(System.Type evidenceType, System.Reflection.Assembly assembly) => throw null;
            public virtual System.Type[] GetHostSuppliedAppDomainEvidenceTypes() => throw null;
            public virtual System.Type[] GetHostSuppliedAssemblyEvidenceTypes(System.Reflection.Assembly assembly) => throw null;
            public virtual System.Security.Policy.Evidence ProvideAppDomainEvidence(System.Security.Policy.Evidence inputEvidence) => throw null;
            public virtual System.Security.Policy.Evidence ProvideAssemblyEvidence(System.Reflection.Assembly loadedAssembly, System.Security.Policy.Evidence inputEvidence) => throw null;
            public virtual System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence evidence) => throw null;
        }
        [System.Flags]
        public enum HostSecurityManagerOptions
        {
            AllFlags = 31,
            HostAppDomainEvidence = 1,
            HostAssemblyEvidence = 4,
            HostDetermineApplicationTrust = 8,
            HostPolicyLevel = 2,
            HostResolvePolicy = 16,
            None = 0,
        }
        public interface IEvidenceFactory
        {
            System.Security.Policy.Evidence Evidence { get; }
        }
        public interface ISecurityPolicyEncodable
        {
            void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level);
            System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level);
        }
        public sealed class NamedPermissionSet : System.Security.PermissionSet
        {
            public override System.Security.PermissionSet Copy() => throw null;
            public System.Security.NamedPermissionSet Copy(string name) => throw null;
            public NamedPermissionSet(System.Security.NamedPermissionSet permSet) : base(default(System.Security.Permissions.PermissionState)) => throw null;
            public NamedPermissionSet(string name) : base(default(System.Security.Permissions.PermissionState)) => throw null;
            public NamedPermissionSet(string name, System.Security.Permissions.PermissionState state) : base(default(System.Security.Permissions.PermissionState)) => throw null;
            public NamedPermissionSet(string name, System.Security.PermissionSet permSet) : base(default(System.Security.Permissions.PermissionState)) => throw null;
            public string Description { get => throw null; set { } }
            public override bool Equals(object o) => throw null;
            public override void FromXml(System.Security.SecurityElement et) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; set { } }
            public override System.Security.SecurityElement ToXml() => throw null;
        }
        namespace Permissions
        {
            public sealed class DataProtectionPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public DataProtectionPermission(System.Security.Permissions.PermissionState state) => throw null;
                public DataProtectionPermission(System.Security.Permissions.DataProtectionPermissionFlags flag) => throw null;
                public System.Security.Permissions.DataProtectionPermissionFlags Flags { get => throw null; set { } }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class DataProtectionPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public DataProtectionPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.DataProtectionPermissionFlags Flags { get => throw null; set { } }
                public bool ProtectData { get => throw null; set { } }
                public bool ProtectMemory { get => throw null; set { } }
                public bool UnprotectData { get => throw null; set { } }
                public bool UnprotectMemory { get => throw null; set { } }
            }
            [System.Flags]
            public enum DataProtectionPermissionFlags
            {
                NoFlags = 0,
                ProtectData = 1,
                UnprotectData = 2,
                ProtectMemory = 4,
                UnprotectMemory = 8,
                AllFlags = 15,
            }
            public sealed class EnvironmentPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void AddPathList(System.Security.Permissions.EnvironmentPermissionAccess flag, string pathList) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public EnvironmentPermission(System.Security.Permissions.EnvironmentPermissionAccess flag, string pathList) => throw null;
                public EnvironmentPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public string GetPathList(System.Security.Permissions.EnvironmentPermissionAccess flag) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public void SetPathList(System.Security.Permissions.EnvironmentPermissionAccess flag, string pathList) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }
            [System.Flags]
            public enum EnvironmentPermissionAccess
            {
                AllAccess = 3,
                NoAccess = 0,
                Read = 1,
                Write = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class EnvironmentPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string All { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public EnvironmentPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Read { get => throw null; set { } }
                public string Write { get => throw null; set { } }
            }
            public sealed class FileDialogPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.FileDialogPermissionAccess Access { get => throw null; set { } }
                public override System.Security.IPermission Copy() => throw null;
                public FileDialogPermission(System.Security.Permissions.FileDialogPermissionAccess access) => throw null;
                public FileDialogPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.Flags]
            public enum FileDialogPermissionAccess
            {
                None = 0,
                Open = 1,
                OpenSave = 3,
                Save = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class FileDialogPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public FileDialogPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool Open { get => throw null; set { } }
                public bool Save { get => throw null; set { } }
            }
            public sealed class FileIOPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void AddPathList(System.Security.Permissions.FileIOPermissionAccess access, string path) => throw null;
                public void AddPathList(System.Security.Permissions.FileIOPermissionAccess access, string[] pathList) => throw null;
                public System.Security.Permissions.FileIOPermissionAccess AllFiles { get => throw null; set { } }
                public System.Security.Permissions.FileIOPermissionAccess AllLocalFiles { get => throw null; set { } }
                public override System.Security.IPermission Copy() => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, string path) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, string[] pathList) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, System.Security.AccessControl.AccessControlActions actions, string path) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, System.Security.AccessControl.AccessControlActions actions, string[] pathList) => throw null;
                public FileIOPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override bool Equals(object o) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override int GetHashCode() => throw null;
                public string[] GetPathList(System.Security.Permissions.FileIOPermissionAccess access) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public void SetPathList(System.Security.Permissions.FileIOPermissionAccess access, string path) => throw null;
                public void SetPathList(System.Security.Permissions.FileIOPermissionAccess access, string[] pathList) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }
            [System.Flags]
            public enum FileIOPermissionAccess
            {
                AllAccess = 15,
                Append = 4,
                NoAccess = 0,
                PathDiscovery = 8,
                Read = 1,
                Write = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class FileIOPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string All { get => throw null; set { } }
                public System.Security.Permissions.FileIOPermissionAccess AllFiles { get => throw null; set { } }
                public System.Security.Permissions.FileIOPermissionAccess AllLocalFiles { get => throw null; set { } }
                public string Append { get => throw null; set { } }
                public string ChangeAccessControl { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public FileIOPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string PathDiscovery { get => throw null; set { } }
                public string Read { get => throw null; set { } }
                public string ViewAccessControl { get => throw null; set { } }
                public string ViewAndModify { get => throw null; set { } }
                public string Write { get => throw null; set { } }
            }
            public sealed class GacIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public GacIdentityPermission() => throw null;
                public GacIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class GacIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public GacIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4205, AllowMultiple = true, Inherited = false)]
            public sealed class HostProtectionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public HostProtectionAttribute() : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public HostProtectionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool ExternalProcessMgmt { get => throw null; set { } }
                public bool ExternalThreading { get => throw null; set { } }
                public bool MayLeakOnAbort { get => throw null; set { } }
                public System.Security.Permissions.HostProtectionResource Resources { get => throw null; set { } }
                public bool SecurityInfrastructure { get => throw null; set { } }
                public bool SelfAffectingProcessMgmt { get => throw null; set { } }
                public bool SelfAffectingThreading { get => throw null; set { } }
                public bool SharedState { get => throw null; set { } }
                public bool Synchronization { get => throw null; set { } }
                public bool UI { get => throw null; set { } }
            }
            [System.Flags]
            public enum HostProtectionResource
            {
                All = 511,
                ExternalProcessMgmt = 4,
                ExternalThreading = 16,
                MayLeakOnAbort = 256,
                None = 0,
                SecurityInfrastructure = 64,
                SelfAffectingProcessMgmt = 8,
                SelfAffectingThreading = 32,
                SharedState = 2,
                Synchronization = 1,
                UI = 128,
            }
            public enum IsolatedStorageContainment
            {
                None = 0,
                DomainIsolationByUser = 16,
                ApplicationIsolationByUser = 21,
                AssemblyIsolationByUser = 32,
                DomainIsolationByMachine = 48,
                AssemblyIsolationByMachine = 64,
                ApplicationIsolationByMachine = 69,
                DomainIsolationByRoamingUser = 80,
                AssemblyIsolationByRoamingUser = 96,
                ApplicationIsolationByRoamingUser = 101,
                AdministerIsolatedStorageByUser = 112,
                UnrestrictedIsolatedStorage = 240,
            }
            public sealed class IsolatedStorageFilePermission : System.Security.Permissions.IsolatedStoragePermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public IsolatedStorageFilePermission(System.Security.Permissions.PermissionState state) : base(default(System.Security.Permissions.PermissionState)) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class IsolatedStorageFilePermissionAttribute : System.Security.Permissions.IsolatedStoragePermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public IsolatedStorageFilePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }
            public abstract class IsolatedStoragePermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                protected IsolatedStoragePermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public System.Security.Permissions.IsolatedStorageContainment UsageAllowed { get => throw null; set { } }
                public long UserQuota { get => throw null; set { } }
            }
            public abstract class IsolatedStoragePermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                protected IsolatedStoragePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.IsolatedStorageContainment UsageAllowed { get => throw null; set { } }
                public long UserQuota { get => throw null; set { } }
            }
            public interface IUnrestrictedPermission
            {
                bool IsUnrestricted();
            }
            public sealed class KeyContainerPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.KeyContainerPermissionAccessEntryCollection AccessEntries { get => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public KeyContainerPermission(System.Security.Permissions.PermissionState state) => throw null;
                public KeyContainerPermission(System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public KeyContainerPermission(System.Security.Permissions.KeyContainerPermissionFlags flags, System.Security.Permissions.KeyContainerPermissionAccessEntry[] accessList) => throw null;
                public System.Security.Permissions.KeyContainerPermissionFlags Flags { get => throw null; }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            public sealed class KeyContainerPermissionAccessEntry
            {
                public KeyContainerPermissionAccessEntry(string keyContainerName, System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public KeyContainerPermissionAccessEntry(System.Security.Cryptography.CspParameters parameters, System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public KeyContainerPermissionAccessEntry(string keyStore, string providerName, int providerType, string keyContainerName, int keySpec, System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public override bool Equals(object o) => throw null;
                public System.Security.Permissions.KeyContainerPermissionFlags Flags { get => throw null; set { } }
                public override int GetHashCode() => throw null;
                public string KeyContainerName { get => throw null; set { } }
                public int KeySpec { get => throw null; set { } }
                public string KeyStore { get => throw null; set { } }
                public string ProviderName { get => throw null; set { } }
                public int ProviderType { get => throw null; set { } }
            }
            public sealed class KeyContainerPermissionAccessEntryCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Permissions.KeyContainerPermissionAccessEntry accessEntry) => throw null;
                public void Clear() => throw null;
                public void CopyTo(System.Security.Permissions.KeyContainerPermissionAccessEntry[] array, int index) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public KeyContainerPermissionAccessEntryCollection() => throw null;
                public System.Security.Permissions.KeyContainerPermissionAccessEntryEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(System.Security.Permissions.KeyContainerPermissionAccessEntry accessEntry) => throw null;
                public bool IsSynchronized { get => throw null; }
                public void Remove(System.Security.Permissions.KeyContainerPermissionAccessEntry accessEntry) => throw null;
                public object SyncRoot { get => throw null; }
                public System.Security.Permissions.KeyContainerPermissionAccessEntry this[int index] { get => throw null; }
            }
            public sealed class KeyContainerPermissionAccessEntryEnumerator : System.Collections.IEnumerator
            {
                public KeyContainerPermissionAccessEntryEnumerator() => throw null;
                public System.Security.Permissions.KeyContainerPermissionAccessEntry Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class KeyContainerPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public KeyContainerPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.KeyContainerPermissionFlags Flags { get => throw null; set { } }
                public string KeyContainerName { get => throw null; set { } }
                public int KeySpec { get => throw null; set { } }
                public string KeyStore { get => throw null; set { } }
                public string ProviderName { get => throw null; set { } }
                public int ProviderType { get => throw null; set { } }
            }
            public enum KeyContainerPermissionFlags
            {
                NoFlags = 0,
                Create = 1,
                Open = 2,
                Delete = 4,
                Import = 16,
                Export = 32,
                Sign = 256,
                Decrypt = 512,
                ViewAcl = 4096,
                ChangeAcl = 8192,
                AllFlags = 13111,
            }
            public sealed class MediaPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.MediaPermissionAudio Audio { get => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public MediaPermission() => throw null;
                public MediaPermission(System.Security.Permissions.PermissionState state) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionAudio permissionAudio) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionVideo permissionVideo) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionImage permissionImage) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionAudio permissionAudio, System.Security.Permissions.MediaPermissionVideo permissionVideo, System.Security.Permissions.MediaPermissionImage permissionImage) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public System.Security.Permissions.MediaPermissionImage Image { get => throw null; }
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public System.Security.Permissions.MediaPermissionVideo Video { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class MediaPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public System.Security.Permissions.MediaPermissionAudio Audio { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public MediaPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.MediaPermissionImage Image { get => throw null; set { } }
                public System.Security.Permissions.MediaPermissionVideo Video { get => throw null; set { } }
            }
            public enum MediaPermissionAudio
            {
                NoAudio = 0,
                SiteOfOriginAudio = 1,
                SafeAudio = 2,
                AllAudio = 3,
            }
            public enum MediaPermissionImage
            {
                NoImage = 0,
                SiteOfOriginImage = 1,
                SafeImage = 2,
                AllImage = 3,
            }
            public enum MediaPermissionVideo
            {
                NoVideo = 0,
                SiteOfOriginVideo = 1,
                SafeVideo = 2,
                AllVideo = 3,
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class PermissionSetAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.PermissionSet CreatePermissionSet() => throw null;
                public PermissionSetAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string File { get => throw null; set { } }
                public string Hex { get => throw null; set { } }
                public string Name { get => throw null; set { } }
                public bool UnicodeEncoded { get => throw null; set { } }
                public string XML { get => throw null; set { } }
            }
            public sealed class PrincipalPermission : System.Security.IPermission, System.Security.ISecurityEncodable, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.IPermission Copy() => throw null;
                public PrincipalPermission(System.Security.Permissions.PermissionState state) => throw null;
                public PrincipalPermission(string name, string role) => throw null;
                public PrincipalPermission(string name, string role, bool isAuthenticated) => throw null;
                public void Demand() => throw null;
                public override bool Equals(object obj) => throw null;
                public void FromXml(System.Security.SecurityElement elem) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)68, AllowMultiple = true, Inherited = false)]
            public sealed class PrincipalPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool Authenticated { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public PrincipalPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Name { get => throw null; set { } }
                public string Role { get => throw null; set { } }
            }
            public sealed class PublisherIdentityPermission : System.Security.CodeAccessPermission
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; set { } }
                public override System.Security.IPermission Copy() => throw null;
                public PublisherIdentityPermission(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                public PublisherIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class PublisherIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string CertFile { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public PublisherIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string SignedFile { get => throw null; set { } }
                public string X509Certificate { get => throw null; set { } }
            }
            public sealed class ReflectionPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public ReflectionPermission(System.Security.Permissions.PermissionState state) => throw null;
                public ReflectionPermission(System.Security.Permissions.ReflectionPermissionFlag flag) => throw null;
                public System.Security.Permissions.ReflectionPermissionFlag Flags { get => throw null; set { } }
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class ReflectionPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public ReflectionPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.ReflectionPermissionFlag Flags { get => throw null; set { } }
                public bool MemberAccess { get => throw null; set { } }
                public bool ReflectionEmit { get => throw null; set { } }
                public bool RestrictedMemberAccess { get => throw null; set { } }
                public bool TypeInformation { get => throw null; set { } }
            }
            [System.Flags]
            public enum ReflectionPermissionFlag
            {
                AllFlags = 7,
                MemberAccess = 2,
                NoFlags = 0,
                ReflectionEmit = 4,
                RestrictedMemberAccess = 8,
                TypeInformation = 1,
            }
            public sealed class RegistryPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void AddPathList(System.Security.Permissions.RegistryPermissionAccess access, string pathList) => throw null;
                public void AddPathList(System.Security.Permissions.RegistryPermissionAccess access, System.Security.AccessControl.AccessControlActions actions, string pathList) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public RegistryPermission(System.Security.Permissions.PermissionState state) => throw null;
                public RegistryPermission(System.Security.Permissions.RegistryPermissionAccess access, System.Security.AccessControl.AccessControlActions control, string pathList) => throw null;
                public RegistryPermission(System.Security.Permissions.RegistryPermissionAccess access, string pathList) => throw null;
                public override void FromXml(System.Security.SecurityElement elem) => throw null;
                public string GetPathList(System.Security.Permissions.RegistryPermissionAccess access) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public void SetPathList(System.Security.Permissions.RegistryPermissionAccess access, string pathList) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }
            [System.Flags]
            public enum RegistryPermissionAccess
            {
                AllAccess = 7,
                Create = 4,
                NoAccess = 0,
                Read = 1,
                Write = 2,
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class RegistryPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string All { get => throw null; set { } }
                public string ChangeAccessControl { get => throw null; set { } }
                public string Create { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public RegistryPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Read { get => throw null; set { } }
                public string ViewAccessControl { get => throw null; set { } }
                public string ViewAndModify { get => throw null; set { } }
                public string Write { get => throw null; set { } }
            }
            public abstract class ResourcePermissionBase : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                protected void AddPermissionAccess(System.Security.Permissions.ResourcePermissionBaseEntry entry) => throw null;
                public const string Any = default;
                protected void Clear() => throw null;
                public override System.Security.IPermission Copy() => throw null;
                protected ResourcePermissionBase() => throw null;
                protected ResourcePermissionBase(System.Security.Permissions.PermissionState state) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                protected System.Security.Permissions.ResourcePermissionBaseEntry[] GetPermissionEntries() => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public const string Local = default;
                protected System.Type PermissionAccessType { get => throw null; set { } }
                protected void RemovePermissionAccess(System.Security.Permissions.ResourcePermissionBaseEntry entry) => throw null;
                protected string[] TagNames { get => throw null; set { } }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            public class ResourcePermissionBaseEntry
            {
                public ResourcePermissionBaseEntry() => throw null;
                public ResourcePermissionBaseEntry(int permissionAccess, string[] permissionAccessPath) => throw null;
                public int PermissionAccess { get => throw null; }
                public string[] PermissionAccessPath { get => throw null; }
            }
            public sealed class SecurityPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public SecurityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public SecurityPermission(System.Security.Permissions.SecurityPermissionFlag flag) => throw null;
                public System.Security.Permissions.SecurityPermissionFlag Flags { get => throw null; set { } }
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            public sealed class SiteIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public SiteIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public SiteIdentityPermission(string site) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public string Site { get => throw null; set { } }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class SiteIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public SiteIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Site { get => throw null; set { } }
            }
            public sealed class StorePermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public StorePermission(System.Security.Permissions.PermissionState state) => throw null;
                public StorePermission(System.Security.Permissions.StorePermissionFlags flag) => throw null;
                public System.Security.Permissions.StorePermissionFlags Flags { get => throw null; set { } }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class StorePermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool AddToStore { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public bool CreateStore { get => throw null; set { } }
                public StorePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool DeleteStore { get => throw null; set { } }
                public bool EnumerateCertificates { get => throw null; set { } }
                public bool EnumerateStores { get => throw null; set { } }
                public System.Security.Permissions.StorePermissionFlags Flags { get => throw null; set { } }
                public bool OpenStore { get => throw null; set { } }
                public bool RemoveFromStore { get => throw null; set { } }
            }
            [System.Flags]
            public enum StorePermissionFlags
            {
                NoFlags = 0,
                CreateStore = 1,
                DeleteStore = 2,
                EnumerateStores = 4,
                OpenStore = 16,
                AddToStore = 32,
                RemoveFromStore = 64,
                EnumerateCertificates = 128,
                AllFlags = 247,
            }
            public sealed class StrongNameIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public StrongNameIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public StrongNameIdentityPermission(System.Security.Permissions.StrongNamePublicKeyBlob blob, string name, System.Version version) => throw null;
                public override void FromXml(System.Security.SecurityElement e) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public string Name { get => throw null; set { } }
                public System.Security.Permissions.StrongNamePublicKeyBlob PublicKey { get => throw null; set { } }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public System.Version Version { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class StrongNameIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public StrongNameIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Name { get => throw null; set { } }
                public string PublicKey { get => throw null; set { } }
                public string Version { get => throw null; set { } }
            }
            public sealed class StrongNamePublicKeyBlob
            {
                public StrongNamePublicKeyBlob(byte[] publicKey) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
            }
            public sealed class TypeDescriptorPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public TypeDescriptorPermission(System.Security.Permissions.PermissionState state) => throw null;
                public TypeDescriptorPermission(System.Security.Permissions.TypeDescriptorPermissionFlags flag) => throw null;
                public System.Security.Permissions.TypeDescriptorPermissionFlags Flags { get => throw null; set { } }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class TypeDescriptorPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public TypeDescriptorPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.TypeDescriptorPermissionFlags Flags { get => throw null; set { } }
                public bool RestrictedRegistrationAccess { get => throw null; set { } }
            }
            [System.Flags]
            public enum TypeDescriptorPermissionFlags
            {
                NoFlags = 0,
                RestrictedRegistrationAccess = 1,
            }
            public sealed class UIPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.UIPermissionClipboard Clipboard { get => throw null; set { } }
                public override System.Security.IPermission Copy() => throw null;
                public UIPermission(System.Security.Permissions.PermissionState state) => throw null;
                public UIPermission(System.Security.Permissions.UIPermissionClipboard clipboardFlag) => throw null;
                public UIPermission(System.Security.Permissions.UIPermissionWindow windowFlag) => throw null;
                public UIPermission(System.Security.Permissions.UIPermissionWindow windowFlag, System.Security.Permissions.UIPermissionClipboard clipboardFlag) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public System.Security.Permissions.UIPermissionWindow Window { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class UIPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public System.Security.Permissions.UIPermissionClipboard Clipboard { get => throw null; set { } }
                public override System.Security.IPermission CreatePermission() => throw null;
                public UIPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.UIPermissionWindow Window { get => throw null; set { } }
            }
            public enum UIPermissionClipboard
            {
                AllClipboard = 2,
                NoClipboard = 0,
                OwnClipboard = 1,
            }
            public enum UIPermissionWindow
            {
                AllWindows = 3,
                NoWindows = 0,
                SafeSubWindows = 1,
                SafeTopLevelWindows = 2,
            }
            public sealed class UrlIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public UrlIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public UrlIdentityPermission(string site) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public string Url { get => throw null; set { } }
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class UrlIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public UrlIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Url { get => throw null; set { } }
            }
            public sealed class WebBrowserPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public WebBrowserPermission() => throw null;
                public WebBrowserPermission(System.Security.Permissions.PermissionState state) => throw null;
                public WebBrowserPermission(System.Security.Permissions.WebBrowserPermissionLevel webBrowserPermissionLevel) => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public System.Security.Permissions.WebBrowserPermissionLevel Level { get => throw null; set { } }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class WebBrowserPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public WebBrowserPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.WebBrowserPermissionLevel Level { get => throw null; set { } }
            }
            public enum WebBrowserPermissionLevel
            {
                None = 0,
                Safe = 1,
                Unrestricted = 2,
            }
            public sealed class ZoneIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public ZoneIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public ZoneIdentityPermission(System.Security.SecurityZone zone) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public System.Security.SecurityZone SecurityZone { get => throw null; set { } }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)109, AllowMultiple = true, Inherited = false)]
            public sealed class ZoneIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public ZoneIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.SecurityZone Zone { get => throw null; set { } }
            }
        }
        namespace Policy
        {
            public sealed class AllMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public AllMembershipCondition() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public sealed class ApplicationDirectory : System.Security.Policy.EvidenceBase
            {
                public object Copy() => throw null;
                public ApplicationDirectory(string name) => throw null;
                public string Directory { get => throw null; }
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
            }
            public sealed class ApplicationDirectoryMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public ApplicationDirectoryMembershipCondition() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public sealed class ApplicationTrust : System.Security.Policy.EvidenceBase, System.Security.ISecurityEncodable
            {
                public System.ApplicationIdentity ApplicationIdentity { get => throw null; set { } }
                public ApplicationTrust() => throw null;
                public ApplicationTrust(System.ApplicationIdentity identity) => throw null;
                public ApplicationTrust(System.Security.PermissionSet defaultGrantSet, System.Collections.Generic.IEnumerable<System.Security.Policy.StrongName> fullTrustAssemblies) => throw null;
                public System.Security.Policy.PolicyStatement DefaultGrantSet { get => throw null; set { } }
                public object ExtraInfo { get => throw null; set { } }
                public void FromXml(System.Security.SecurityElement element) => throw null;
                public System.Collections.Generic.IList<System.Security.Policy.StrongName> FullTrustAssemblies { get => throw null; }
                public bool IsApplicationTrustedToRun { get => throw null; set { } }
                public bool Persist { get => throw null; set { } }
                public System.Security.SecurityElement ToXml() => throw null;
            }
            public sealed class ApplicationTrustCollection : System.Collections.ICollection, System.Collections.IEnumerable
            {
                public int Add(System.Security.Policy.ApplicationTrust trust) => throw null;
                public void AddRange(System.Security.Policy.ApplicationTrust[] trusts) => throw null;
                public void AddRange(System.Security.Policy.ApplicationTrustCollection trusts) => throw null;
                public void Clear() => throw null;
                public void CopyTo(System.Security.Policy.ApplicationTrust[] array, int index) => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Policy.ApplicationTrustCollection Find(System.ApplicationIdentity applicationIdentity, System.Security.Policy.ApplicationVersionMatch versionMatch) => throw null;
                public System.Security.Policy.ApplicationTrustEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public void Remove(System.Security.Policy.ApplicationTrust trust) => throw null;
                public void Remove(System.ApplicationIdentity applicationIdentity, System.Security.Policy.ApplicationVersionMatch versionMatch) => throw null;
                public void RemoveRange(System.Security.Policy.ApplicationTrust[] trusts) => throw null;
                public void RemoveRange(System.Security.Policy.ApplicationTrustCollection trusts) => throw null;
                public object SyncRoot { get => throw null; }
                public System.Security.Policy.ApplicationTrust this[int index] { get => throw null; }
                public System.Security.Policy.ApplicationTrust this[string appFullName] { get => throw null; }
            }
            public sealed class ApplicationTrustEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Policy.ApplicationTrust Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }
            public enum ApplicationVersionMatch
            {
                MatchAllVersions = 1,
                MatchExactVersion = 0,
            }
            public class CodeConnectAccess
            {
                public static readonly string AnyScheme;
                public static System.Security.Policy.CodeConnectAccess CreateAnySchemeAccess(int allowPort) => throw null;
                public static System.Security.Policy.CodeConnectAccess CreateOriginSchemeAccess(int allowPort) => throw null;
                public CodeConnectAccess(string allowScheme, int allowPort) => throw null;
                public static readonly int DefaultPort;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public static readonly int OriginPort;
                public static readonly string OriginScheme;
                public int Port { get => throw null; }
                public string Scheme { get => throw null; }
            }
            public abstract class CodeGroup
            {
                public void AddChild(System.Security.Policy.CodeGroup group) => throw null;
                public virtual string AttributeString { get => throw null; }
                public System.Collections.IList Children { get => throw null; set { } }
                public abstract System.Security.Policy.CodeGroup Copy();
                protected virtual void CreateXml(System.Security.SecurityElement element, System.Security.Policy.PolicyLevel level) => throw null;
                protected CodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Policy.PolicyStatement policy) => throw null;
                public string Description { get => throw null; set { } }
                public override bool Equals(object o) => throw null;
                public bool Equals(System.Security.Policy.CodeGroup cg, bool compareChildren) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.Policy.IMembershipCondition MembershipCondition { get => throw null; set { } }
                public abstract string MergeLogic { get; }
                public string Name { get => throw null; set { } }
                protected virtual void ParseXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public virtual string PermissionSetName { get => throw null; }
                public System.Security.Policy.PolicyStatement PolicyStatement { get => throw null; set { } }
                public void RemoveChild(System.Security.Policy.CodeGroup group) => throw null;
                public abstract System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence);
                public abstract System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence);
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public sealed class FileCodeGroup : System.Security.Policy.CodeGroup
            {
                public override string AttributeString { get => throw null; }
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                protected override void CreateXml(System.Security.SecurityElement element, System.Security.Policy.PolicyLevel level) => throw null;
                public FileCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Permissions.FileIOPermissionAccess access) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string MergeLogic { get => throw null; }
                protected override void ParseXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override string PermissionSetName { get => throw null; }
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }
            public sealed class FirstMatchCodeGroup : System.Security.Policy.CodeGroup
            {
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                public FirstMatchCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Policy.PolicyStatement policy) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                public override string MergeLogic { get => throw null; }
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }
            public sealed class GacInstalled : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public GacInstalled() => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
            }
            public sealed class GacMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public GacMembershipCondition() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public sealed class Hash : System.Security.Policy.EvidenceBase, System.Runtime.Serialization.ISerializable
            {
                public static System.Security.Policy.Hash CreateMD5(byte[] md5) => throw null;
                public static System.Security.Policy.Hash CreateSHA1(byte[] sha1) => throw null;
                public static System.Security.Policy.Hash CreateSHA256(byte[] sha256) => throw null;
                public Hash(System.Reflection.Assembly assembly) => throw null;
                public byte[] GenerateHash(System.Security.Cryptography.HashAlgorithm hashAlg) => throw null;
                public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public byte[] MD5 { get => throw null; }
                public byte[] SHA1 { get => throw null; }
                public byte[] SHA256 { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class HashMembershipCondition : System.Runtime.Serialization.IDeserializationCallback, System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable, System.Runtime.Serialization.ISerializable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public HashMembershipCondition(System.Security.Cryptography.HashAlgorithm hashAlg, byte[] value) => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Security.Cryptography.HashAlgorithm HashAlgorithm { get => throw null; set { } }
                public byte[] HashValue { get => throw null; set { } }
                void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public interface IIdentityPermissionFactory
            {
                System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence);
            }
            public interface IMembershipCondition : System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                bool Check(System.Security.Policy.Evidence evidence);
                System.Security.Policy.IMembershipCondition Copy();
                bool Equals(object obj);
                string ToString();
            }
            public sealed class NetCodeGroup : System.Security.Policy.CodeGroup
            {
                public static readonly string AbsentOriginScheme;
                public void AddConnectAccess(string originScheme, System.Security.Policy.CodeConnectAccess connectAccess) => throw null;
                public static readonly string AnyOtherOriginScheme;
                public override string AttributeString { get => throw null; }
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                protected override void CreateXml(System.Security.SecurityElement element, System.Security.Policy.PolicyLevel level) => throw null;
                public NetCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                public override bool Equals(object o) => throw null;
                public System.Collections.DictionaryEntry[] GetConnectAccessRules() => throw null;
                public override int GetHashCode() => throw null;
                public override string MergeLogic { get => throw null; }
                protected override void ParseXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override string PermissionSetName { get => throw null; }
                public void ResetConnectAccess() => throw null;
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }
            public sealed class PermissionRequestEvidence : System.Security.Policy.EvidenceBase
            {
                public System.Security.Policy.PermissionRequestEvidence Copy() => throw null;
                public PermissionRequestEvidence(System.Security.PermissionSet request, System.Security.PermissionSet optional, System.Security.PermissionSet denied) => throw null;
                public System.Security.PermissionSet DeniedPermissions { get => throw null; }
                public System.Security.PermissionSet OptionalPermissions { get => throw null; }
                public System.Security.PermissionSet RequestedPermissions { get => throw null; }
                public override string ToString() => throw null;
            }
            public class PolicyException : System.SystemException
            {
                public PolicyException() => throw null;
                protected PolicyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public PolicyException(string message) => throw null;
                public PolicyException(string message, System.Exception exception) => throw null;
            }
            public sealed class PolicyLevel
            {
                public void AddFullTrustAssembly(System.Security.Policy.StrongName sn) => throw null;
                public void AddFullTrustAssembly(System.Security.Policy.StrongNameMembershipCondition snMC) => throw null;
                public void AddNamedPermissionSet(System.Security.NamedPermissionSet permSet) => throw null;
                public System.Security.NamedPermissionSet ChangeNamedPermissionSet(string name, System.Security.PermissionSet pSet) => throw null;
                public static System.Security.Policy.PolicyLevel CreateAppDomainLevel() => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public System.Collections.IList FullTrustAssemblies { get => throw null; }
                public System.Security.NamedPermissionSet GetNamedPermissionSet(string name) => throw null;
                public string Label { get => throw null; }
                public System.Collections.IList NamedPermissionSets { get => throw null; }
                public void Recover() => throw null;
                public void RemoveFullTrustAssembly(System.Security.Policy.StrongName sn) => throw null;
                public void RemoveFullTrustAssembly(System.Security.Policy.StrongNameMembershipCondition snMC) => throw null;
                public System.Security.NamedPermissionSet RemoveNamedPermissionSet(System.Security.NamedPermissionSet permSet) => throw null;
                public System.Security.NamedPermissionSet RemoveNamedPermissionSet(string name) => throw null;
                public void Reset() => throw null;
                public System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.CodeGroup RootCodeGroup { get => throw null; set { } }
                public string StoreLocation { get => throw null; }
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.PolicyLevelType Type { get => throw null; }
            }
            public sealed class PolicyStatement : System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public System.Security.Policy.PolicyStatementAttribute Attributes { get => throw null; set { } }
                public string AttributeString { get => throw null; }
                public System.Security.Policy.PolicyStatement Copy() => throw null;
                public PolicyStatement(System.Security.PermissionSet permSet) => throw null;
                public PolicyStatement(System.Security.PermissionSet permSet, System.Security.Policy.PolicyStatementAttribute attributes) => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement et) => throw null;
                public void FromXml(System.Security.SecurityElement et, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.PermissionSet PermissionSet { get => throw null; set { } }
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            [System.Flags]
            public enum PolicyStatementAttribute
            {
                All = 3,
                Exclusive = 1,
                LevelFinal = 2,
                Nothing = 0,
            }
            public sealed class Publisher : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; }
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public Publisher(System.Security.Cryptography.X509Certificates.X509Certificate cert) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
            }
            public sealed class PublisherMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; set { } }
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public PublisherMembershipCondition(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public sealed class Site : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public static System.Security.Policy.Site CreateFromUrl(string url) => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public Site(string name) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class SiteMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public SiteMembershipCondition(string site) => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public string Site { get => throw null; set { } }
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
            public sealed class StrongName : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public StrongName(System.Security.Permissions.StrongNamePublicKeyBlob blob, string name, System.Version version) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; }
                public System.Security.Permissions.StrongNamePublicKeyBlob PublicKey { get => throw null; }
                public override string ToString() => throw null;
                public System.Version Version { get => throw null; }
            }
            public sealed class StrongNameMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public StrongNameMembershipCondition(System.Security.Permissions.StrongNamePublicKeyBlob blob, string name, System.Version version) => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; set { } }
                public System.Security.Permissions.StrongNamePublicKeyBlob PublicKey { get => throw null; set { } }
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Version Version { get => throw null; set { } }
            }
            public class TrustManagerContext
            {
                public TrustManagerContext() => throw null;
                public TrustManagerContext(System.Security.Policy.TrustManagerUIContext uiContext) => throw null;
                public virtual bool IgnorePersistedDecision { get => throw null; set { } }
                public virtual bool KeepAlive { get => throw null; set { } }
                public virtual bool NoPrompt { get => throw null; set { } }
                public virtual bool Persist { get => throw null; set { } }
                public virtual System.ApplicationIdentity PreviousApplicationIdentity { get => throw null; set { } }
                public virtual System.Security.Policy.TrustManagerUIContext UIContext { get => throw null; set { } }
            }
            public enum TrustManagerUIContext
            {
                Install = 0,
                Run = 2,
                Upgrade = 1,
            }
            public sealed class UnionCodeGroup : System.Security.Policy.CodeGroup
            {
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                public UnionCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Policy.PolicyStatement policy) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                public override string MergeLogic { get => throw null; }
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }
            public sealed class Url : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public Url(string name) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public string Value { get => throw null; }
            }
            public sealed class UrlMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public UrlMembershipCondition(string url) => throw null;
                public override bool Equals(object obj) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public string Url { get => throw null; set { } }
            }
            public sealed class Zone : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public static System.Security.Policy.Zone CreateFromUrl(string url) => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public Zone(System.Security.SecurityZone zone) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.SecurityZone SecurityZone { get => throw null; }
                public override string ToString() => throw null;
            }
            public sealed class ZoneMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityEncodable, System.Security.ISecurityPolicyEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public ZoneMembershipCondition(System.Security.SecurityZone zone) => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.SecurityZone SecurityZone { get => throw null; set { } }
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
            }
        }
        public enum PolicyLevelType
        {
            AppDomain = 3,
            Enterprise = 2,
            Machine = 1,
            User = 0,
        }
        public sealed class SecurityContext : System.IDisposable
        {
            public static System.Security.SecurityContext Capture() => throw null;
            public System.Security.SecurityContext CreateCopy() => throw null;
            public void Dispose() => throw null;
            public static bool IsFlowSuppressed() => throw null;
            public static bool IsWindowsIdentityFlowSuppressed() => throw null;
            public static void RestoreFlow() => throw null;
            public static void Run(System.Security.SecurityContext securityContext, System.Threading.ContextCallback callback, object state) => throw null;
            public static System.Threading.AsyncFlowControl SuppressFlow() => throw null;
            public static System.Threading.AsyncFlowControl SuppressFlowWindowsIdentity() => throw null;
        }
        public enum SecurityContextSource
        {
            CurrentAppDomain = 0,
            CurrentAssembly = 1,
        }
        public static class SecurityManager
        {
            public static bool CheckExecutionRights { get => throw null; set { } }
            public static bool CurrentThreadRequiresSecurityContextCapture() => throw null;
            public static System.Security.PermissionSet GetStandardSandbox(System.Security.Policy.Evidence evidence) => throw null;
            public static void GetZoneAndOrigin(out System.Collections.ArrayList zone, out System.Collections.ArrayList origin) => throw null;
            public static bool IsGranted(System.Security.IPermission perm) => throw null;
            public static System.Security.Policy.PolicyLevel LoadPolicyLevelFromFile(string path, System.Security.PolicyLevelType type) => throw null;
            public static System.Security.Policy.PolicyLevel LoadPolicyLevelFromString(string str, System.Security.PolicyLevelType type) => throw null;
            public static System.Collections.IEnumerator PolicyHierarchy() => throw null;
            public static System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence evidence) => throw null;
            public static System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence evidence, System.Security.PermissionSet reqdPset, System.Security.PermissionSet optPset, System.Security.PermissionSet denyPset, out System.Security.PermissionSet denied) => throw null;
            public static System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence[] evidences) => throw null;
            public static System.Collections.IEnumerator ResolvePolicyGroups(System.Security.Policy.Evidence evidence) => throw null;
            public static System.Security.PermissionSet ResolveSystemPolicy(System.Security.Policy.Evidence evidence) => throw null;
            public static void SavePolicy() => throw null;
            public static void SavePolicyLevel(System.Security.Policy.PolicyLevel level) => throw null;
            public static bool SecurityEnabled { get => throw null; set { } }
        }
        public abstract class SecurityState
        {
            protected SecurityState() => throw null;
            public abstract void EnsureState();
            public bool IsStateAvailable() => throw null;
        }
        public enum SecurityZone
        {
            Internet = 3,
            Intranet = 1,
            MyComputer = 0,
            NoZone = -1,
            Trusted = 2,
            Untrusted = 4,
        }
        public sealed class XmlSyntaxException : System.SystemException
        {
            public XmlSyntaxException() => throw null;
            public XmlSyntaxException(int lineNumber) => throw null;
            public XmlSyntaxException(int lineNumber, string message) => throw null;
            public XmlSyntaxException(string message) => throw null;
            public XmlSyntaxException(string message, System.Exception inner) => throw null;
        }
    }
    namespace ServiceProcess
    {
        public sealed class ServiceControllerPermission : System.Security.Permissions.ResourcePermissionBase
        {
            public ServiceControllerPermission() => throw null;
            public ServiceControllerPermission(System.Security.Permissions.PermissionState state) => throw null;
            public ServiceControllerPermission(System.ServiceProcess.ServiceControllerPermissionAccess permissionAccess, string machineName, string serviceName) => throw null;
            public ServiceControllerPermission(System.ServiceProcess.ServiceControllerPermissionEntry[] permissionAccessEntries) => throw null;
            public System.ServiceProcess.ServiceControllerPermissionEntryCollection PermissionEntries { get => throw null; }
        }
        [System.Flags]
        public enum ServiceControllerPermissionAccess
        {
            None = 0,
            Browse = 2,
            Control = 6,
        }
        [System.AttributeUsage((System.AttributeTargets)621, AllowMultiple = true, Inherited = false)]
        public class ServiceControllerPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public ServiceControllerPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string MachineName { get => throw null; set { } }
            public System.ServiceProcess.ServiceControllerPermissionAccess PermissionAccess { get => throw null; set { } }
            public string ServiceName { get => throw null; set { } }
        }
        public class ServiceControllerPermissionEntry
        {
            public ServiceControllerPermissionEntry() => throw null;
            public ServiceControllerPermissionEntry(System.ServiceProcess.ServiceControllerPermissionAccess permissionAccess, string machineName, string serviceName) => throw null;
            public string MachineName { get => throw null; }
            public System.ServiceProcess.ServiceControllerPermissionAccess PermissionAccess { get => throw null; }
            public string ServiceName { get => throw null; }
        }
        public class ServiceControllerPermissionEntryCollection : System.Collections.CollectionBase
        {
            public int Add(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public void AddRange(System.ServiceProcess.ServiceControllerPermissionEntry[] value) => throw null;
            public void AddRange(System.ServiceProcess.ServiceControllerPermissionEntryCollection value) => throw null;
            public bool Contains(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public void CopyTo(System.ServiceProcess.ServiceControllerPermissionEntry[] array, int index) => throw null;
            public int IndexOf(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public void Insert(int index, System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            protected override void OnClear() => throw null;
            protected override void OnInsert(int index, object value) => throw null;
            protected override void OnRemove(int index, object value) => throw null;
            protected override void OnSet(int index, object oldValue, object newValue) => throw null;
            public void Remove(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public System.ServiceProcess.ServiceControllerPermissionEntry this[int index] { get => throw null; set { } }
        }
    }
    namespace Transactions
    {
        public sealed class DistributedTransactionPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public override System.Security.IPermission Copy() => throw null;
            public DistributedTransactionPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767, AllowMultiple = true)]
        public sealed class DistributedTransactionPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public DistributedTransactionPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public bool Unrestricted { get => throw null; set { } }
        }
    }
    namespace Web
    {
        public sealed class AspNetHostingPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public override System.Security.IPermission Copy() => throw null;
            public AspNetHostingPermission(System.Security.Permissions.PermissionState state) => throw null;
            public AspNetHostingPermission(System.Web.AspNetHostingPermissionLevel level) => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public System.Web.AspNetHostingPermissionLevel Level { get => throw null; set { } }
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }
        [System.AttributeUsage((System.AttributeTargets)32767, AllowMultiple = true, Inherited = false)]
        public sealed class AspNetHostingPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public AspNetHostingPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public System.Web.AspNetHostingPermissionLevel Level { get => throw null; set { } }
        }
        public enum AspNetHostingPermissionLevel
        {
            None = 100,
            Minimal = 200,
            Low = 300,
            Medium = 400,
            High = 500,
            Unrestricted = 600,
        }
    }
    namespace Xaml
    {
        namespace Permissions
        {
            public sealed class XamlLoadPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Collections.Generic.IList<System.Xaml.Permissions.XamlAccessLevel> AllowedAccess { get => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public XamlLoadPermission(System.Security.Permissions.PermissionState state) => throw null;
                public XamlLoadPermission(System.Xaml.Permissions.XamlAccessLevel allowedAccess) => throw null;
                public XamlLoadPermission(System.Collections.Generic.IEnumerable<System.Xaml.Permissions.XamlAccessLevel> allowedAccess) => throw null;
                public override bool Equals(object obj) => throw null;
                public override void FromXml(System.Security.SecurityElement elem) => throw null;
                public override int GetHashCode() => throw null;
                public bool Includes(System.Xaml.Permissions.XamlAccessLevel requestedAccess) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }
        }
    }
}
