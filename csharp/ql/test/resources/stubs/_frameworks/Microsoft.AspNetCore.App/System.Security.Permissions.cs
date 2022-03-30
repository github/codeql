// This file contains auto-generated code.

namespace System
{
    // Generated from `System.ApplicationIdentity` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
    public class ApplicationIdentity : System.Runtime.Serialization.ISerializable
    {
        public ApplicationIdentity(string applicationIdentityFullName) => throw null;
        public string CodeBase { get => throw null; }
        public string FullName { get => throw null; }
        void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
        public override string ToString() => throw null;
    }

    namespace Configuration
    {
        // Generated from `System.Configuration.ConfigurationPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public ConfigurationPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override System.Security.IPermission Copy() => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }

        // Generated from `System.Configuration.ConfigurationPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ConfigurationPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public ConfigurationPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public override System.Security.IPermission CreatePermission() => throw null;
        }

    }
    namespace Data
    {
        namespace Common
        {
            // Generated from `System.Data.Common.DBDataPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class DBDataPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public virtual void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public bool AllowBlankPassword { get => throw null; set => throw null; }
                protected void Clear() => throw null;
                public override System.Security.IPermission Copy() => throw null;
                protected virtual System.Data.Common.DBDataPermission CreateInstance() => throw null;
                protected DBDataPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
                protected DBDataPermission(System.Security.Permissions.PermissionState state) => throw null;
                protected DBDataPermission(System.Data.Common.DBDataPermissionAttribute permissionAttribute) => throw null;
                protected DBDataPermission(System.Data.Common.DBDataPermission permission) => throw null;
                protected DBDataPermission() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Data.Common.DBDataPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class DBDataPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool AllowBlankPassword { get => throw null; set => throw null; }
                public string ConnectionString { get => throw null; set => throw null; }
                protected DBDataPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Data.KeyRestrictionBehavior KeyRestrictionBehavior { get => throw null; set => throw null; }
                public string KeyRestrictions { get => throw null; set => throw null; }
                public bool ShouldSerializeConnectionString() => throw null;
                public bool ShouldSerializeKeyRestrictions() => throw null;
            }

        }
        namespace Odbc
        {
            // Generated from `System.Data.Odbc.OdbcPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class OdbcPermission : System.Data.Common.DBDataPermission
            {
                public override void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public OdbcPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
                public OdbcPermission(System.Security.Permissions.PermissionState state) => throw null;
                public OdbcPermission() => throw null;
            }

            // Generated from `System.Data.Odbc.OdbcPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class OdbcPermissionAttribute : System.Data.Common.DBDataPermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public OdbcPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

        }
        namespace OleDb
        {
            // Generated from `System.Data.OleDb.OleDbPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class OleDbPermission : System.Data.Common.DBDataPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public OleDbPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
                public OleDbPermission(System.Security.Permissions.PermissionState state) => throw null;
                public OleDbPermission() => throw null;
                public string Provider { get => throw null; set => throw null; }
            }

            // Generated from `System.Data.OleDb.OleDbPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class OleDbPermissionAttribute : System.Data.Common.DBDataPermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public OleDbPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Provider { get => throw null; set => throw null; }
            }

        }
        namespace OracleClient
        {
            // Generated from `System.Data.OracleClient.OraclePermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class OraclePermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public bool AllowBlankPassword { get => throw null; set => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public OraclePermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Data.OracleClient.OraclePermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class OraclePermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool AllowBlankPassword { get => throw null; set => throw null; }
                public string ConnectionString { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Data.KeyRestrictionBehavior KeyRestrictionBehavior { get => throw null; set => throw null; }
                public string KeyRestrictions { get => throw null; set => throw null; }
                public OraclePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool ShouldSerializeConnectionString() => throw null;
                public bool ShouldSerializeKeyRestrictions() => throw null;
            }

        }
        namespace SqlClient
        {
            // Generated from `System.Data.SqlClient.SqlClientPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SqlClientPermission : System.Data.Common.DBDataPermission
            {
                public override void Add(string connectionString, string restrictions, System.Data.KeyRestrictionBehavior behavior) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public SqlClientPermission(System.Security.Permissions.PermissionState state, bool allowBlankPassword) => throw null;
                public SqlClientPermission(System.Security.Permissions.PermissionState state) => throw null;
                public SqlClientPermission() => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlClientPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SqlClientPermissionAttribute : System.Data.Common.DBDataPermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public SqlClientPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

        }
    }
    namespace Diagnostics
    {
        // Generated from `System.Diagnostics.EventLogPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogPermission : System.Security.Permissions.ResourcePermissionBase
        {
            public EventLogPermission(System.Security.Permissions.PermissionState state) => throw null;
            public EventLogPermission(System.Diagnostics.EventLogPermissionEntry[] permissionAccessEntries) => throw null;
            public EventLogPermission(System.Diagnostics.EventLogPermissionAccess permissionAccess, string machineName) => throw null;
            public EventLogPermission() => throw null;
            public System.Diagnostics.EventLogPermissionEntryCollection PermissionEntries { get => throw null; }
        }

        // Generated from `System.Diagnostics.EventLogPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum EventLogPermissionAccess
        {
            Administer,
            Audit,
            Browse,
            Instrument,
            None,
            Write,
        }

        // Generated from `System.Diagnostics.EventLogPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public EventLogPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string MachineName { get => throw null; set => throw null; }
            public System.Diagnostics.EventLogPermissionAccess PermissionAccess { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.EventLogPermissionEntry` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogPermissionEntry
        {
            public EventLogPermissionEntry(System.Diagnostics.EventLogPermissionAccess permissionAccess, string machineName) => throw null;
            public string MachineName { get => throw null; }
            public System.Diagnostics.EventLogPermissionAccess PermissionAccess { get => throw null; }
        }

        // Generated from `System.Diagnostics.EventLogPermissionEntryCollection` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EventLogPermissionEntryCollection : System.Collections.CollectionBase
        {
            public int Add(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public void AddRange(System.Diagnostics.EventLogPermissionEntry[] value) => throw null;
            public void AddRange(System.Diagnostics.EventLogPermissionEntryCollection value) => throw null;
            public bool Contains(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public void CopyTo(System.Diagnostics.EventLogPermissionEntry[] array, int index) => throw null;
            public int IndexOf(System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public void Insert(int index, System.Diagnostics.EventLogPermissionEntry value) => throw null;
            public System.Diagnostics.EventLogPermissionEntry this[int index] { get => throw null; set => throw null; }
            protected override void OnClear() => throw null;
            protected override void OnInsert(int index, object value) => throw null;
            protected override void OnRemove(int index, object value) => throw null;
            protected override void OnSet(int index, object oldValue, object newValue) => throw null;
            public void Remove(System.Diagnostics.EventLogPermissionEntry value) => throw null;
        }

        // Generated from `System.Diagnostics.PerformanceCounterPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PerformanceCounterPermission : System.Security.Permissions.ResourcePermissionBase
        {
            public PerformanceCounterPermission(System.Security.Permissions.PermissionState state) => throw null;
            public PerformanceCounterPermission(System.Diagnostics.PerformanceCounterPermissionEntry[] permissionAccessEntries) => throw null;
            public PerformanceCounterPermission(System.Diagnostics.PerformanceCounterPermissionAccess permissionAccess, string machineName, string categoryName) => throw null;
            public PerformanceCounterPermission() => throw null;
            public System.Diagnostics.PerformanceCounterPermissionEntryCollection PermissionEntries { get => throw null; }
        }

        // Generated from `System.Diagnostics.PerformanceCounterPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum PerformanceCounterPermissionAccess
        {
            Administer,
            Browse,
            Instrument,
            None,
            Read,
            Write,
        }

        // Generated from `System.Diagnostics.PerformanceCounterPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PerformanceCounterPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public string CategoryName { get => throw null; set => throw null; }
            public override System.Security.IPermission CreatePermission() => throw null;
            public string MachineName { get => throw null; set => throw null; }
            public PerformanceCounterPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public System.Diagnostics.PerformanceCounterPermissionAccess PermissionAccess { get => throw null; set => throw null; }
        }

        // Generated from `System.Diagnostics.PerformanceCounterPermissionEntry` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PerformanceCounterPermissionEntry
        {
            public string CategoryName { get => throw null; }
            public string MachineName { get => throw null; }
            public PerformanceCounterPermissionEntry(System.Diagnostics.PerformanceCounterPermissionAccess permissionAccess, string machineName, string categoryName) => throw null;
            public System.Diagnostics.PerformanceCounterPermissionAccess PermissionAccess { get => throw null; }
        }

        // Generated from `System.Diagnostics.PerformanceCounterPermissionEntryCollection` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class PerformanceCounterPermissionEntryCollection : System.Collections.CollectionBase
        {
            public int Add(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public void AddRange(System.Diagnostics.PerformanceCounterPermissionEntry[] value) => throw null;
            public void AddRange(System.Diagnostics.PerformanceCounterPermissionEntryCollection value) => throw null;
            public bool Contains(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public void CopyTo(System.Diagnostics.PerformanceCounterPermissionEntry[] array, int index) => throw null;
            public int IndexOf(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public void Insert(int index, System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
            public System.Diagnostics.PerformanceCounterPermissionEntry this[int index] { get => throw null; set => throw null; }
            protected override void OnClear() => throw null;
            protected override void OnInsert(int index, object value) => throw null;
            protected override void OnRemove(int index, object value) => throw null;
            protected override void OnSet(int index, object oldValue, object newValue) => throw null;
            public void Remove(System.Diagnostics.PerformanceCounterPermissionEntry value) => throw null;
        }

    }
    namespace Drawing
    {
        namespace Printing
        {
            // Generated from `System.Drawing.Printing.PrintingPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrintingPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement element) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public System.Drawing.Printing.PrintingPermissionLevel Level { get => throw null; set => throw null; }
                public PrintingPermission(System.Security.Permissions.PermissionState state) => throw null;
                public PrintingPermission(System.Drawing.Printing.PrintingPermissionLevel printingLevel) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Drawing.Printing.PrintingPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrintingPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Drawing.Printing.PrintingPermissionLevel Level { get => throw null; set => throw null; }
                public PrintingPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Drawing.Printing.PrintingPermissionLevel` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PrintingPermissionLevel
            {
                AllPrinting,
                DefaultPrinting,
                NoPrinting,
                SafePrinting,
            }

        }
    }
    namespace Net
    {
        // Generated from `System.Net.DnsPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DnsPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
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

        // Generated from `System.Net.DnsPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DnsPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public DnsPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
        }

        // Generated from `System.Net.EndpointPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class EndpointPermission
        {
            public override bool Equals(object obj) => throw null;
            public override int GetHashCode() => throw null;
            public string Hostname { get => throw null; }
            public int Port { get => throw null; }
            public System.Net.TransportType Transport { get => throw null; }
        }

        // Generated from `System.Net.NetworkAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum NetworkAccess
        {
            Accept,
            Connect,
        }

        // Generated from `System.Net.SocketPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SocketPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public System.Collections.IEnumerator AcceptList { get => throw null; }
            public void AddPermission(System.Net.NetworkAccess access, System.Net.TransportType transport, string hostName, int portNumber) => throw null;
            public const int AllPorts = default;
            public System.Collections.IEnumerator ConnectList { get => throw null; }
            public override System.Security.IPermission Copy() => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public SocketPermission(System.Security.Permissions.PermissionState state) => throw null;
            public SocketPermission(System.Net.NetworkAccess access, System.Net.TransportType transport, string hostName, int portNumber) => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }

        // Generated from `System.Net.SocketPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SocketPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public string Access { get => throw null; set => throw null; }
            public override System.Security.IPermission CreatePermission() => throw null;
            public string Host { get => throw null; set => throw null; }
            public string Port { get => throw null; set => throw null; }
            public SocketPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string Transport { get => throw null; set => throw null; }
        }

        // Generated from `System.Net.TransportType` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum TransportType
        {
            All,
            ConnectionOriented,
            Connectionless,
            Tcp,
            Udp,
        }

        // Generated from `System.Net.WebPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class WebPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public System.Collections.IEnumerator AcceptList { get => throw null; }
            public void AddPermission(System.Net.NetworkAccess access, string uriString) => throw null;
            public void AddPermission(System.Net.NetworkAccess access, System.Text.RegularExpressions.Regex uriRegex) => throw null;
            public System.Collections.IEnumerator ConnectList { get => throw null; }
            public override System.Security.IPermission Copy() => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            public WebPermission(System.Security.Permissions.PermissionState state) => throw null;
            public WebPermission(System.Net.NetworkAccess access, string uriString) => throw null;
            public WebPermission(System.Net.NetworkAccess access, System.Text.RegularExpressions.Regex uriRegex) => throw null;
            public WebPermission() => throw null;
        }

        // Generated from `System.Net.WebPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class WebPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public string Accept { get => throw null; set => throw null; }
            public string AcceptPattern { get => throw null; set => throw null; }
            public string Connect { get => throw null; set => throw null; }
            public string ConnectPattern { get => throw null; set => throw null; }
            public override System.Security.IPermission CreatePermission() => throw null;
            public WebPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
        }

        namespace Mail
        {
            // Generated from `System.Net.Mail.SmtpAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum SmtpAccess
            {
                Connect,
                ConnectToUnrestrictedPort,
                None,
            }

            // Generated from `System.Net.Mail.SmtpPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SmtpPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Net.Mail.SmtpAccess Access { get => throw null; }
                public void AddPermission(System.Net.Mail.SmtpAccess access) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public SmtpPermission(bool unrestricted) => throw null;
                public SmtpPermission(System.Security.Permissions.PermissionState state) => throw null;
                public SmtpPermission(System.Net.Mail.SmtpAccess access) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Net.Mail.SmtpPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SmtpPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string Access { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public SmtpPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

        }
        namespace NetworkInformation
        {
            // Generated from `System.Net.NetworkInformation.NetworkInformationAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum NetworkInformationAccess
            {
                None,
                Ping,
                Read,
            }

            // Generated from `System.Net.NetworkInformation.NetworkInformationPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class NetworkInformationPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Net.NetworkInformation.NetworkInformationAccess Access { get => throw null; }
                public void AddPermission(System.Net.NetworkInformation.NetworkInformationAccess access) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public NetworkInformationPermission(System.Security.Permissions.PermissionState state) => throw null;
                public NetworkInformationPermission(System.Net.NetworkInformation.NetworkInformationAccess access) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Net.NetworkInformation.NetworkInformationPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class NetworkInformationPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string Access { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public NetworkInformationPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

        }
        namespace PeerToPeer
        {
            // Generated from `System.Net.PeerToPeer.PnrpPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PnrpPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement e) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public PnrpPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Net.PeerToPeer.PnrpPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PnrpPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public PnrpPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Net.PeerToPeer.PnrpScope` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum PnrpScope
            {
                All,
                Global,
                LinkLocal,
                SiteLocal,
            }

            namespace Collaboration
            {
                // Generated from `System.Net.PeerToPeer.Collaboration.PeerCollaborationPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class PeerCollaborationPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
                {
                    public override System.Security.IPermission Copy() => throw null;
                    public override void FromXml(System.Security.SecurityElement e) => throw null;
                    public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                    public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                    public bool IsUnrestricted() => throw null;
                    public PeerCollaborationPermission(System.Security.Permissions.PermissionState state) => throw null;
                    public override System.Security.SecurityElement ToXml() => throw null;
                    public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                }

                // Generated from `System.Net.PeerToPeer.Collaboration.PeerCollaborationPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
                public class PeerCollaborationPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
                {
                    public override System.Security.IPermission CreatePermission() => throw null;
                    public PeerCollaborationPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                }

            }
        }
    }
    namespace Security
    {
        // Generated from `System.Security.CodeAccessPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class CodeAccessPermission : System.Security.IStackWalk, System.Security.ISecurityEncodable, System.Security.IPermission
        {
            public void Assert() => throw null;
            protected CodeAccessPermission() => throw null;
            public abstract System.Security.IPermission Copy();
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

        // Generated from `System.Security.HostProtectionException` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HostProtectionException : System.SystemException
        {
            public System.Security.Permissions.HostProtectionResource DemandedResources { get => throw null; }
            public HostProtectionException(string message, System.Security.Permissions.HostProtectionResource protectedResources, System.Security.Permissions.HostProtectionResource demandedResources) => throw null;
            public HostProtectionException(string message, System.Exception e) => throw null;
            public HostProtectionException(string message) => throw null;
            public HostProtectionException() => throw null;
            protected HostProtectionException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            public System.Security.Permissions.HostProtectionResource ProtectedResources { get => throw null; }
            public override string ToString() => throw null;
        }

        // Generated from `System.Security.HostSecurityManager` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class HostSecurityManager
        {
            public virtual System.Security.Policy.ApplicationTrust DetermineApplicationTrust(System.Security.Policy.Evidence applicationEvidence, System.Security.Policy.Evidence activatorEvidence, System.Security.Policy.TrustManagerContext context) => throw null;
            public virtual System.Security.Policy.PolicyLevel DomainPolicy { get => throw null; }
            public virtual System.Security.HostSecurityManagerOptions Flags { get => throw null; }
            public virtual System.Security.Policy.EvidenceBase GenerateAppDomainEvidence(System.Type evidenceType) => throw null;
            public virtual System.Security.Policy.EvidenceBase GenerateAssemblyEvidence(System.Type evidenceType, System.Reflection.Assembly assembly) => throw null;
            public virtual System.Type[] GetHostSuppliedAppDomainEvidenceTypes() => throw null;
            public virtual System.Type[] GetHostSuppliedAssemblyEvidenceTypes(System.Reflection.Assembly assembly) => throw null;
            public HostSecurityManager() => throw null;
            public virtual System.Security.Policy.Evidence ProvideAppDomainEvidence(System.Security.Policy.Evidence inputEvidence) => throw null;
            public virtual System.Security.Policy.Evidence ProvideAssemblyEvidence(System.Reflection.Assembly loadedAssembly, System.Security.Policy.Evidence inputEvidence) => throw null;
            public virtual System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence evidence) => throw null;
        }

        // Generated from `System.Security.HostSecurityManagerOptions` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum HostSecurityManagerOptions
        {
            AllFlags,
            HostAppDomainEvidence,
            HostAssemblyEvidence,
            HostDetermineApplicationTrust,
            HostPolicyLevel,
            HostResolvePolicy,
            None,
        }

        // Generated from `System.Security.IEvidenceFactory` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface IEvidenceFactory
        {
            System.Security.Policy.Evidence Evidence { get; }
        }

        // Generated from `System.Security.ISecurityPolicyEncodable` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public interface ISecurityPolicyEncodable
        {
            void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level);
            System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level);
        }

        // Generated from `System.Security.NamedPermissionSet` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class NamedPermissionSet : System.Security.PermissionSet
        {
            public override System.Security.PermissionSet Copy() => throw null;
            public System.Security.NamedPermissionSet Copy(string name) => throw null;
            public string Description { get => throw null; set => throw null; }
            public override bool Equals(object o) => throw null;
            public override void FromXml(System.Security.SecurityElement et) => throw null;
            public override int GetHashCode() => throw null;
            public string Name { get => throw null; set => throw null; }
            public NamedPermissionSet(string name, System.Security.Permissions.PermissionState state) : base(default(System.Security.PermissionSet)) => throw null;
            public NamedPermissionSet(string name, System.Security.PermissionSet permSet) : base(default(System.Security.PermissionSet)) => throw null;
            public NamedPermissionSet(string name) : base(default(System.Security.PermissionSet)) => throw null;
            public NamedPermissionSet(System.Security.NamedPermissionSet permSet) : base(default(System.Security.PermissionSet)) => throw null;
            public override System.Security.SecurityElement ToXml() => throw null;
        }

        // Generated from `System.Security.PolicyLevelType` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum PolicyLevelType
        {
            AppDomain,
            Enterprise,
            Machine,
            User,
        }

        // Generated from `System.Security.SecurityContext` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class SecurityContext : System.IDisposable
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

        // Generated from `System.Security.SecurityContextSource` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum SecurityContextSource
        {
            CurrentAppDomain,
            CurrentAssembly,
        }

        // Generated from `System.Security.SecurityManager` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public static class SecurityManager
        {
            public static bool CheckExecutionRights { get => throw null; set => throw null; }
            public static bool CurrentThreadRequiresSecurityContextCapture() => throw null;
            public static System.Security.PermissionSet GetStandardSandbox(System.Security.Policy.Evidence evidence) => throw null;
            public static void GetZoneAndOrigin(out System.Collections.ArrayList zone, out System.Collections.ArrayList origin) => throw null;
            public static bool IsGranted(System.Security.IPermission perm) => throw null;
            public static System.Security.Policy.PolicyLevel LoadPolicyLevelFromFile(string path, System.Security.PolicyLevelType type) => throw null;
            public static System.Security.Policy.PolicyLevel LoadPolicyLevelFromString(string str, System.Security.PolicyLevelType type) => throw null;
            public static System.Collections.IEnumerator PolicyHierarchy() => throw null;
            public static System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence[] evidences) => throw null;
            public static System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence evidence, System.Security.PermissionSet reqdPset, System.Security.PermissionSet optPset, System.Security.PermissionSet denyPset, out System.Security.PermissionSet denied) => throw null;
            public static System.Security.PermissionSet ResolvePolicy(System.Security.Policy.Evidence evidence) => throw null;
            public static System.Collections.IEnumerator ResolvePolicyGroups(System.Security.Policy.Evidence evidence) => throw null;
            public static System.Security.PermissionSet ResolveSystemPolicy(System.Security.Policy.Evidence evidence) => throw null;
            public static void SavePolicy() => throw null;
            public static void SavePolicyLevel(System.Security.Policy.PolicyLevel level) => throw null;
            public static bool SecurityEnabled { get => throw null; set => throw null; }
        }

        // Generated from `System.Security.SecurityState` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public abstract class SecurityState
        {
            public abstract void EnsureState();
            public bool IsStateAvailable() => throw null;
            protected SecurityState() => throw null;
        }

        // Generated from `System.Security.SecurityZone` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum SecurityZone
        {
            Internet,
            Intranet,
            MyComputer,
            NoZone,
            Trusted,
            Untrusted,
        }

        // Generated from `System.Security.XmlSyntaxException` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class XmlSyntaxException : System.SystemException
        {
            public XmlSyntaxException(string message, System.Exception inner) => throw null;
            public XmlSyntaxException(string message) => throw null;
            public XmlSyntaxException(int lineNumber, string message) => throw null;
            public XmlSyntaxException(int lineNumber) => throw null;
            public XmlSyntaxException() => throw null;
        }

        namespace Permissions
        {
            // Generated from `System.Security.Permissions.DataProtectionPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class DataProtectionPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public DataProtectionPermission(System.Security.Permissions.PermissionState state) => throw null;
                public DataProtectionPermission(System.Security.Permissions.DataProtectionPermissionFlags flag) => throw null;
                public System.Security.Permissions.DataProtectionPermissionFlags Flags { get => throw null; set => throw null; }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.DataProtectionPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class DataProtectionPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public DataProtectionPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.DataProtectionPermissionFlags Flags { get => throw null; set => throw null; }
                public bool ProtectData { get => throw null; set => throw null; }
                public bool ProtectMemory { get => throw null; set => throw null; }
                public bool UnprotectData { get => throw null; set => throw null; }
                public bool UnprotectMemory { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.DataProtectionPermissionFlags` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum DataProtectionPermissionFlags
            {
                AllFlags,
                NoFlags,
                ProtectData,
                ProtectMemory,
                UnprotectData,
                UnprotectMemory,
            }

            // Generated from `System.Security.Permissions.EnvironmentPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class EnvironmentPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void AddPathList(System.Security.Permissions.EnvironmentPermissionAccess flag, string pathList) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public EnvironmentPermission(System.Security.Permissions.PermissionState state) => throw null;
                public EnvironmentPermission(System.Security.Permissions.EnvironmentPermissionAccess flag, string pathList) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public string GetPathList(System.Security.Permissions.EnvironmentPermissionAccess flag) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public void SetPathList(System.Security.Permissions.EnvironmentPermissionAccess flag, string pathList) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }

            // Generated from `System.Security.Permissions.EnvironmentPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum EnvironmentPermissionAccess
            {
                AllAccess,
                NoAccess,
                Read,
                Write,
            }

            // Generated from `System.Security.Permissions.EnvironmentPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class EnvironmentPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string All { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public EnvironmentPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Read { get => throw null; set => throw null; }
                public string Write { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.FileDialogPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FileDialogPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.FileDialogPermissionAccess Access { get => throw null; set => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public FileDialogPermission(System.Security.Permissions.PermissionState state) => throw null;
                public FileDialogPermission(System.Security.Permissions.FileDialogPermissionAccess access) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.FileDialogPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum FileDialogPermissionAccess
            {
                None,
                Open,
                OpenSave,
                Save,
            }

            // Generated from `System.Security.Permissions.FileDialogPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FileDialogPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public FileDialogPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool Open { get => throw null; set => throw null; }
                public bool Save { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.FileIOPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FileIOPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void AddPathList(System.Security.Permissions.FileIOPermissionAccess access, string[] pathList) => throw null;
                public void AddPathList(System.Security.Permissions.FileIOPermissionAccess access, string path) => throw null;
                public System.Security.Permissions.FileIOPermissionAccess AllFiles { get => throw null; set => throw null; }
                public System.Security.Permissions.FileIOPermissionAccess AllLocalFiles { get => throw null; set => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public FileIOPermission(System.Security.Permissions.PermissionState state) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, string[] pathList) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, string path) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, System.Security.AccessControl.AccessControlActions actions, string[] pathList) => throw null;
                public FileIOPermission(System.Security.Permissions.FileIOPermissionAccess access, System.Security.AccessControl.AccessControlActions actions, string path) => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override int GetHashCode() => throw null;
                public string[] GetPathList(System.Security.Permissions.FileIOPermissionAccess access) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public void SetPathList(System.Security.Permissions.FileIOPermissionAccess access, string[] pathList) => throw null;
                public void SetPathList(System.Security.Permissions.FileIOPermissionAccess access, string path) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }

            // Generated from `System.Security.Permissions.FileIOPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum FileIOPermissionAccess
            {
                AllAccess,
                Append,
                NoAccess,
                PathDiscovery,
                Read,
                Write,
            }

            // Generated from `System.Security.Permissions.FileIOPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FileIOPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string All { get => throw null; set => throw null; }
                public System.Security.Permissions.FileIOPermissionAccess AllFiles { get => throw null; set => throw null; }
                public System.Security.Permissions.FileIOPermissionAccess AllLocalFiles { get => throw null; set => throw null; }
                public string Append { get => throw null; set => throw null; }
                public string ChangeAccessControl { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public FileIOPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string PathDiscovery { get => throw null; set => throw null; }
                public string Read { get => throw null; set => throw null; }
                public string ViewAccessControl { get => throw null; set => throw null; }
                public string ViewAndModify { get => throw null; set => throw null; }
                public string Write { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.GacIdentityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GacIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public GacIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public GacIdentityPermission() => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.GacIdentityPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GacIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public GacIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.HostProtectionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class HostProtectionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public bool ExternalProcessMgmt { get => throw null; set => throw null; }
                public bool ExternalThreading { get => throw null; set => throw null; }
                public HostProtectionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public HostProtectionAttribute() : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool MayLeakOnAbort { get => throw null; set => throw null; }
                public System.Security.Permissions.HostProtectionResource Resources { get => throw null; set => throw null; }
                public bool SecurityInfrastructure { get => throw null; set => throw null; }
                public bool SelfAffectingProcessMgmt { get => throw null; set => throw null; }
                public bool SelfAffectingThreading { get => throw null; set => throw null; }
                public bool SharedState { get => throw null; set => throw null; }
                public bool Synchronization { get => throw null; set => throw null; }
                public bool UI { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.HostProtectionResource` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum HostProtectionResource
            {
                All,
                ExternalProcessMgmt,
                ExternalThreading,
                MayLeakOnAbort,
                None,
                SecurityInfrastructure,
                SelfAffectingProcessMgmt,
                SelfAffectingThreading,
                SharedState,
                Synchronization,
                UI,
            }

            // Generated from `System.Security.Permissions.IUnrestrictedPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IUnrestrictedPermission
            {
                bool IsUnrestricted();
            }

            // Generated from `System.Security.Permissions.IsolatedStorageContainment` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum IsolatedStorageContainment
            {
                AdministerIsolatedStorageByUser,
                ApplicationIsolationByMachine,
                ApplicationIsolationByRoamingUser,
                ApplicationIsolationByUser,
                AssemblyIsolationByMachine,
                AssemblyIsolationByRoamingUser,
                AssemblyIsolationByUser,
                DomainIsolationByMachine,
                DomainIsolationByRoamingUser,
                DomainIsolationByUser,
                None,
                UnrestrictedIsolatedStorage,
            }

            // Generated from `System.Security.Permissions.IsolatedStorageFilePermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class IsolatedStorageFilePermission : System.Security.Permissions.IsolatedStoragePermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public IsolatedStorageFilePermission(System.Security.Permissions.PermissionState state) : base(default(System.Security.Permissions.PermissionState)) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.IsolatedStorageFilePermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class IsolatedStorageFilePermissionAttribute : System.Security.Permissions.IsolatedStoragePermissionAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public IsolatedStorageFilePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.IsolatedStoragePermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class IsolatedStoragePermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public bool IsUnrestricted() => throw null;
                protected IsolatedStoragePermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public System.Security.Permissions.IsolatedStorageContainment UsageAllowed { get => throw null; set => throw null; }
                public System.Int64 UserQuota { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.IsolatedStoragePermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class IsolatedStoragePermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                protected IsolatedStoragePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.IsolatedStorageContainment UsageAllowed { get => throw null; set => throw null; }
                public System.Int64 UserQuota { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.KeyContainerPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class KeyContainerPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.KeyContainerPermissionAccessEntryCollection AccessEntries { get => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public System.Security.Permissions.KeyContainerPermissionFlags Flags { get => throw null; }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public KeyContainerPermission(System.Security.Permissions.PermissionState state) => throw null;
                public KeyContainerPermission(System.Security.Permissions.KeyContainerPermissionFlags flags, System.Security.Permissions.KeyContainerPermissionAccessEntry[] accessList) => throw null;
                public KeyContainerPermission(System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.KeyContainerPermissionAccessEntry` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class KeyContainerPermissionAccessEntry
            {
                public override bool Equals(object o) => throw null;
                public System.Security.Permissions.KeyContainerPermissionFlags Flags { get => throw null; set => throw null; }
                public override int GetHashCode() => throw null;
                public string KeyContainerName { get => throw null; set => throw null; }
                public KeyContainerPermissionAccessEntry(string keyStore, string providerName, int providerType, string keyContainerName, int keySpec, System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public KeyContainerPermissionAccessEntry(string keyContainerName, System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public KeyContainerPermissionAccessEntry(System.Security.Cryptography.CspParameters parameters, System.Security.Permissions.KeyContainerPermissionFlags flags) => throw null;
                public int KeySpec { get => throw null; set => throw null; }
                public string KeyStore { get => throw null; set => throw null; }
                public string ProviderName { get => throw null; set => throw null; }
                public int ProviderType { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.KeyContainerPermissionAccessEntryCollection` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class KeyContainerPermissionAccessEntryCollection : System.Collections.IEnumerable, System.Collections.ICollection
            {
                public int Add(System.Security.Permissions.KeyContainerPermissionAccessEntry accessEntry) => throw null;
                public void Clear() => throw null;
                public void CopyTo(System.Security.Permissions.KeyContainerPermissionAccessEntry[] array, int index) => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Permissions.KeyContainerPermissionAccessEntryEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public int IndexOf(System.Security.Permissions.KeyContainerPermissionAccessEntry accessEntry) => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Security.Permissions.KeyContainerPermissionAccessEntry this[int index] { get => throw null; }
                public KeyContainerPermissionAccessEntryCollection() => throw null;
                public void Remove(System.Security.Permissions.KeyContainerPermissionAccessEntry accessEntry) => throw null;
                public object SyncRoot { get => throw null; }
            }

            // Generated from `System.Security.Permissions.KeyContainerPermissionAccessEntryEnumerator` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class KeyContainerPermissionAccessEntryEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Permissions.KeyContainerPermissionAccessEntry Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public KeyContainerPermissionAccessEntryEnumerator() => throw null;
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            // Generated from `System.Security.Permissions.KeyContainerPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class KeyContainerPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.Permissions.KeyContainerPermissionFlags Flags { get => throw null; set => throw null; }
                public string KeyContainerName { get => throw null; set => throw null; }
                public KeyContainerPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public int KeySpec { get => throw null; set => throw null; }
                public string KeyStore { get => throw null; set => throw null; }
                public string ProviderName { get => throw null; set => throw null; }
                public int ProviderType { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.KeyContainerPermissionFlags` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum KeyContainerPermissionFlags
            {
                AllFlags,
                ChangeAcl,
                Create,
                Decrypt,
                Delete,
                Export,
                Import,
                NoFlags,
                Open,
                Sign,
                ViewAcl,
            }

            // Generated from `System.Security.Permissions.MediaPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MediaPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.MediaPermissionAudio Audio { get => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public System.Security.Permissions.MediaPermissionImage Image { get => throw null; }
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public MediaPermission(System.Security.Permissions.PermissionState state) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionVideo permissionVideo) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionImage permissionImage) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionAudio permissionAudio, System.Security.Permissions.MediaPermissionVideo permissionVideo, System.Security.Permissions.MediaPermissionImage permissionImage) => throw null;
                public MediaPermission(System.Security.Permissions.MediaPermissionAudio permissionAudio) => throw null;
                public MediaPermission() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public System.Security.Permissions.MediaPermissionVideo Video { get => throw null; }
            }

            // Generated from `System.Security.Permissions.MediaPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class MediaPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public System.Security.Permissions.MediaPermissionAudio Audio { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.Permissions.MediaPermissionImage Image { get => throw null; set => throw null; }
                public MediaPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.MediaPermissionVideo Video { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.MediaPermissionAudio` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MediaPermissionAudio
            {
                AllAudio,
                NoAudio,
                SafeAudio,
                SiteOfOriginAudio,
            }

            // Generated from `System.Security.Permissions.MediaPermissionImage` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MediaPermissionImage
            {
                AllImage,
                NoImage,
                SafeImage,
                SiteOfOriginImage,
            }

            // Generated from `System.Security.Permissions.MediaPermissionVideo` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum MediaPermissionVideo
            {
                AllVideo,
                NoVideo,
                SafeVideo,
                SiteOfOriginVideo,
            }

            // Generated from `System.Security.Permissions.PermissionSetAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PermissionSetAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.PermissionSet CreatePermissionSet() => throw null;
                public string File { get => throw null; set => throw null; }
                public string Hex { get => throw null; set => throw null; }
                public string Name { get => throw null; set => throw null; }
                public PermissionSetAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool UnicodeEncoded { get => throw null; set => throw null; }
                public string XML { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.PrincipalPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrincipalPermission : System.Security.Permissions.IUnrestrictedPermission, System.Security.ISecurityEncodable, System.Security.IPermission
            {
                public System.Security.IPermission Copy() => throw null;
                public void Demand() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement elem) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public PrincipalPermission(string name, string role, bool isAuthenticated) => throw null;
                public PrincipalPermission(string name, string role) => throw null;
                public PrincipalPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }

            // Generated from `System.Security.Permissions.PrincipalPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PrincipalPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool Authenticated { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public string Name { get => throw null; set => throw null; }
                public PrincipalPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Role { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.PublisherIdentityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PublisherIdentityPermission : System.Security.CodeAccessPermission
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; set => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public PublisherIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public PublisherIdentityPermission(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.PublisherIdentityPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PublisherIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string CertFile { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public PublisherIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string SignedFile { get => throw null; set => throw null; }
                public string X509Certificate { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.ReflectionPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ReflectionPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public System.Security.Permissions.ReflectionPermissionFlag Flags { get => throw null; set => throw null; }
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public ReflectionPermission(System.Security.Permissions.ReflectionPermissionFlag flag) => throw null;
                public ReflectionPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }

            // Generated from `System.Security.Permissions.ReflectionPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ReflectionPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.Permissions.ReflectionPermissionFlag Flags { get => throw null; set => throw null; }
                public bool MemberAccess { get => throw null; set => throw null; }
                public bool ReflectionEmit { get => throw null; set => throw null; }
                public ReflectionPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public bool RestrictedMemberAccess { get => throw null; set => throw null; }
                public bool TypeInformation { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.ReflectionPermissionFlag` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum ReflectionPermissionFlag
            {
                AllFlags,
                MemberAccess,
                NoFlags,
                ReflectionEmit,
                RestrictedMemberAccess,
                TypeInformation,
            }

            // Generated from `System.Security.Permissions.RegistryPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class RegistryPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public void AddPathList(System.Security.Permissions.RegistryPermissionAccess access, string pathList) => throw null;
                public void AddPathList(System.Security.Permissions.RegistryPermissionAccess access, System.Security.AccessControl.AccessControlActions actions, string pathList) => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement elem) => throw null;
                public string GetPathList(System.Security.Permissions.RegistryPermissionAccess access) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public RegistryPermission(System.Security.Permissions.RegistryPermissionAccess access, string pathList) => throw null;
                public RegistryPermission(System.Security.Permissions.RegistryPermissionAccess access, System.Security.AccessControl.AccessControlActions control, string pathList) => throw null;
                public RegistryPermission(System.Security.Permissions.PermissionState state) => throw null;
                public void SetPathList(System.Security.Permissions.RegistryPermissionAccess access, string pathList) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
            }

            // Generated from `System.Security.Permissions.RegistryPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum RegistryPermissionAccess
            {
                AllAccess,
                Create,
                NoAccess,
                Read,
                Write,
            }

            // Generated from `System.Security.Permissions.RegistryPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class RegistryPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public string All { get => throw null; set => throw null; }
                public string ChangeAccessControl { get => throw null; set => throw null; }
                public string Create { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public string Read { get => throw null; set => throw null; }
                public RegistryPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string ViewAccessControl { get => throw null; set => throw null; }
                public string ViewAndModify { get => throw null; set => throw null; }
                public string Write { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.ResourcePermissionBase` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class ResourcePermissionBase : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                protected void AddPermissionAccess(System.Security.Permissions.ResourcePermissionBaseEntry entry) => throw null;
                public const string Any = default;
                protected void Clear() => throw null;
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                protected System.Security.Permissions.ResourcePermissionBaseEntry[] GetPermissionEntries() => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public const string Local = default;
                protected System.Type PermissionAccessType { get => throw null; set => throw null; }
                protected void RemovePermissionAccess(System.Security.Permissions.ResourcePermissionBaseEntry entry) => throw null;
                protected ResourcePermissionBase(System.Security.Permissions.PermissionState state) => throw null;
                protected ResourcePermissionBase() => throw null;
                protected string[] TagNames { get => throw null; set => throw null; }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.ResourcePermissionBaseEntry` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ResourcePermissionBaseEntry
            {
                public int PermissionAccess { get => throw null; }
                public string[] PermissionAccessPath { get => throw null; }
                public ResourcePermissionBaseEntry(int permissionAccess, string[] permissionAccessPath) => throw null;
                public ResourcePermissionBaseEntry() => throw null;
            }

            // Generated from `System.Security.Permissions.SecurityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SecurityPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public System.Security.Permissions.SecurityPermissionFlag Flags { get => throw null; set => throw null; }
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public SecurityPermission(System.Security.Permissions.SecurityPermissionFlag flag) => throw null;
                public SecurityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.SiteIdentityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SiteIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public string Site { get => throw null; set => throw null; }
                public SiteIdentityPermission(string site) => throw null;
                public SiteIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.SiteIdentityPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SiteIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public string Site { get => throw null; set => throw null; }
                public SiteIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.StorePermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StorePermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public System.Security.Permissions.StorePermissionFlags Flags { get => throw null; set => throw null; }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public StorePermission(System.Security.Permissions.StorePermissionFlags flag) => throw null;
                public StorePermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.StorePermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StorePermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public bool AddToStore { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public bool CreateStore { get => throw null; set => throw null; }
                public bool DeleteStore { get => throw null; set => throw null; }
                public bool EnumerateCertificates { get => throw null; set => throw null; }
                public bool EnumerateStores { get => throw null; set => throw null; }
                public System.Security.Permissions.StorePermissionFlags Flags { get => throw null; set => throw null; }
                public bool OpenStore { get => throw null; set => throw null; }
                public bool RemoveFromStore { get => throw null; set => throw null; }
                public StorePermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.StorePermissionFlags` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum StorePermissionFlags
            {
                AddToStore,
                AllFlags,
                CreateStore,
                DeleteStore,
                EnumerateCertificates,
                EnumerateStores,
                NoFlags,
                OpenStore,
                RemoveFromStore,
            }

            // Generated from `System.Security.Permissions.StrongNameIdentityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StrongNameIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement e) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public string Name { get => throw null; set => throw null; }
                public System.Security.Permissions.StrongNamePublicKeyBlob PublicKey { get => throw null; set => throw null; }
                public StrongNameIdentityPermission(System.Security.Permissions.StrongNamePublicKeyBlob blob, string name, System.Version version) => throw null;
                public StrongNameIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public System.Version Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.StrongNameIdentityPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StrongNameIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public string Name { get => throw null; set => throw null; }
                public string PublicKey { get => throw null; set => throw null; }
                public StrongNameIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public string Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.StrongNamePublicKeyBlob` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StrongNamePublicKeyBlob
            {
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public StrongNamePublicKeyBlob(System.Byte[] publicKey) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Permissions.TypeDescriptorPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class TypeDescriptorPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public System.Security.Permissions.TypeDescriptorPermissionFlags Flags { get => throw null; set => throw null; }
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public TypeDescriptorPermission(System.Security.Permissions.TypeDescriptorPermissionFlags flag) => throw null;
                public TypeDescriptorPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
            }

            // Generated from `System.Security.Permissions.TypeDescriptorPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class TypeDescriptorPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.Permissions.TypeDescriptorPermissionFlags Flags { get => throw null; set => throw null; }
                public bool RestrictedRegistrationAccess { get => throw null; set => throw null; }
                public TypeDescriptorPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.TypeDescriptorPermissionFlags` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum TypeDescriptorPermissionFlags
            {
                NoFlags,
                RestrictedRegistrationAccess,
            }

            // Generated from `System.Security.Permissions.UIPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UIPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Security.Permissions.UIPermissionClipboard Clipboard { get => throw null; set => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public UIPermission(System.Security.Permissions.UIPermissionWindow windowFlag, System.Security.Permissions.UIPermissionClipboard clipboardFlag) => throw null;
                public UIPermission(System.Security.Permissions.UIPermissionWindow windowFlag) => throw null;
                public UIPermission(System.Security.Permissions.UIPermissionClipboard clipboardFlag) => throw null;
                public UIPermission(System.Security.Permissions.PermissionState state) => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public System.Security.Permissions.UIPermissionWindow Window { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.UIPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UIPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public System.Security.Permissions.UIPermissionClipboard Clipboard { get => throw null; set => throw null; }
                public override System.Security.IPermission CreatePermission() => throw null;
                public UIPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
                public System.Security.Permissions.UIPermissionWindow Window { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Permissions.UIPermissionClipboard` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum UIPermissionClipboard
            {
                AllClipboard,
                NoClipboard,
                OwnClipboard,
            }

            // Generated from `System.Security.Permissions.UIPermissionWindow` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum UIPermissionWindow
            {
                AllWindows,
                NoWindows,
                SafeSubWindows,
                SafeTopLevelWindows,
            }

            // Generated from `System.Security.Permissions.UrlIdentityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UrlIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public string Url { get => throw null; set => throw null; }
                public UrlIdentityPermission(string site) => throw null;
                public UrlIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
            }

            // Generated from `System.Security.Permissions.UrlIdentityPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UrlIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public string Url { get => throw null; set => throw null; }
                public UrlIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.WebBrowserPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class WebBrowserPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public System.Security.Permissions.WebBrowserPermissionLevel Level { get => throw null; set => throw null; }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public WebBrowserPermission(System.Security.Permissions.WebBrowserPermissionLevel webBrowserPermissionLevel) => throw null;
                public WebBrowserPermission(System.Security.Permissions.PermissionState state) => throw null;
                public WebBrowserPermission() => throw null;
            }

            // Generated from `System.Security.Permissions.WebBrowserPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class WebBrowserPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.Permissions.WebBrowserPermissionLevel Level { get => throw null; set => throw null; }
                public WebBrowserPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

            // Generated from `System.Security.Permissions.WebBrowserPermissionLevel` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum WebBrowserPermissionLevel
            {
                None,
                Safe,
                Unrestricted,
            }

            // Generated from `System.Security.Permissions.ZoneIdentityPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ZoneIdentityPermission : System.Security.CodeAccessPermission
            {
                public override System.Security.IPermission Copy() => throw null;
                public override void FromXml(System.Security.SecurityElement esd) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public System.Security.SecurityZone SecurityZone { get => throw null; set => throw null; }
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
                public ZoneIdentityPermission(System.Security.SecurityZone zone) => throw null;
                public ZoneIdentityPermission(System.Security.Permissions.PermissionState state) => throw null;
            }

            // Generated from `System.Security.Permissions.ZoneIdentityPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ZoneIdentityPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
            {
                public override System.Security.IPermission CreatePermission() => throw null;
                public System.Security.SecurityZone Zone { get => throw null; set => throw null; }
                public ZoneIdentityPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            }

        }
        namespace Policy
        {
            // Generated from `System.Security.Policy.AllMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class AllMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public AllMembershipCondition() => throw null;
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.ApplicationDirectory` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ApplicationDirectory : System.Security.Policy.EvidenceBase
            {
                public ApplicationDirectory(string name) => throw null;
                public object Copy() => throw null;
                public string Directory { get => throw null; }
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Policy.ApplicationDirectoryMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ApplicationDirectoryMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public ApplicationDirectoryMembershipCondition() => throw null;
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.ApplicationTrust` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ApplicationTrust : System.Security.Policy.EvidenceBase, System.Security.ISecurityEncodable
            {
                public System.ApplicationIdentity ApplicationIdentity { get => throw null; set => throw null; }
                public ApplicationTrust(System.Security.PermissionSet defaultGrantSet, System.Collections.Generic.IEnumerable<System.Security.Policy.StrongName> fullTrustAssemblies) => throw null;
                public ApplicationTrust(System.ApplicationIdentity identity) => throw null;
                public ApplicationTrust() => throw null;
                public System.Security.Policy.PolicyStatement DefaultGrantSet { get => throw null; set => throw null; }
                public object ExtraInfo { get => throw null; set => throw null; }
                public void FromXml(System.Security.SecurityElement element) => throw null;
                public System.Collections.Generic.IList<System.Security.Policy.StrongName> FullTrustAssemblies { get => throw null; }
                public bool IsApplicationTrustedToRun { get => throw null; set => throw null; }
                public bool Persist { get => throw null; set => throw null; }
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.ApplicationTrustCollection` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ApplicationTrustCollection : System.Collections.IEnumerable, System.Collections.ICollection
            {
                public int Add(System.Security.Policy.ApplicationTrust trust) => throw null;
                public void AddRange(System.Security.Policy.ApplicationTrust[] trusts) => throw null;
                public void AddRange(System.Security.Policy.ApplicationTrustCollection trusts) => throw null;
                public void Clear() => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                public void CopyTo(System.Security.Policy.ApplicationTrust[] array, int index) => throw null;
                public int Count { get => throw null; }
                public System.Security.Policy.ApplicationTrustCollection Find(System.ApplicationIdentity applicationIdentity, System.Security.Policy.ApplicationVersionMatch versionMatch) => throw null;
                public System.Security.Policy.ApplicationTrustEnumerator GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                public bool IsSynchronized { get => throw null; }
                public System.Security.Policy.ApplicationTrust this[string appFullName] { get => throw null; }
                public System.Security.Policy.ApplicationTrust this[int index] { get => throw null; }
                public void Remove(System.Security.Policy.ApplicationTrust trust) => throw null;
                public void Remove(System.ApplicationIdentity applicationIdentity, System.Security.Policy.ApplicationVersionMatch versionMatch) => throw null;
                public void RemoveRange(System.Security.Policy.ApplicationTrust[] trusts) => throw null;
                public void RemoveRange(System.Security.Policy.ApplicationTrustCollection trusts) => throw null;
                public object SyncRoot { get => throw null; }
            }

            // Generated from `System.Security.Policy.ApplicationTrustEnumerator` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ApplicationTrustEnumerator : System.Collections.IEnumerator
            {
                public System.Security.Policy.ApplicationTrust Current { get => throw null; }
                object System.Collections.IEnumerator.Current { get => throw null; }
                public bool MoveNext() => throw null;
                public void Reset() => throw null;
            }

            // Generated from `System.Security.Policy.ApplicationVersionMatch` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum ApplicationVersionMatch
            {
                MatchAllVersions,
                MatchExactVersion,
            }

            // Generated from `System.Security.Policy.CodeConnectAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class CodeConnectAccess
            {
                public static string AnyScheme;
                public CodeConnectAccess(string allowScheme, int allowPort) => throw null;
                public static System.Security.Policy.CodeConnectAccess CreateAnySchemeAccess(int allowPort) => throw null;
                public static System.Security.Policy.CodeConnectAccess CreateOriginSchemeAccess(int allowPort) => throw null;
                public static int DefaultPort;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public static int OriginPort;
                public static string OriginScheme;
                public int Port { get => throw null; }
                public string Scheme { get => throw null; }
            }

            // Generated from `System.Security.Policy.CodeGroup` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class CodeGroup
            {
                public void AddChild(System.Security.Policy.CodeGroup group) => throw null;
                public virtual string AttributeString { get => throw null; }
                public System.Collections.IList Children { get => throw null; set => throw null; }
                protected CodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Policy.PolicyStatement policy) => throw null;
                public abstract System.Security.Policy.CodeGroup Copy();
                protected virtual void CreateXml(System.Security.SecurityElement element, System.Security.Policy.PolicyLevel level) => throw null;
                public string Description { get => throw null; set => throw null; }
                public override bool Equals(object o) => throw null;
                public bool Equals(System.Security.Policy.CodeGroup cg, bool compareChildren) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.Policy.IMembershipCondition MembershipCondition { get => throw null; set => throw null; }
                public abstract string MergeLogic { get; }
                public string Name { get => throw null; set => throw null; }
                protected virtual void ParseXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public virtual string PermissionSetName { get => throw null; }
                public System.Security.Policy.PolicyStatement PolicyStatement { get => throw null; set => throw null; }
                public void RemoveChild(System.Security.Policy.CodeGroup group) => throw null;
                public abstract System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence);
                public abstract System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence);
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.Evidence` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Evidence : System.Collections.IEnumerable, System.Collections.ICollection
            {
                public void AddAssembly(object id) => throw null;
                public void AddAssemblyEvidence<T>(T evidence) where T : System.Security.Policy.EvidenceBase => throw null;
                public void AddHost(object id) => throw null;
                public void AddHostEvidence<T>(T evidence) where T : System.Security.Policy.EvidenceBase => throw null;
                public void Clear() => throw null;
                public System.Security.Policy.Evidence Clone() => throw null;
                public void CopyTo(System.Array array, int index) => throw null;
                public int Count { get => throw null; }
                public Evidence(object[] hostEvidence, object[] assemblyEvidence) => throw null;
                public Evidence(System.Security.Policy.EvidenceBase[] hostEvidence, System.Security.Policy.EvidenceBase[] assemblyEvidence) => throw null;
                public Evidence(System.Security.Policy.Evidence evidence) => throw null;
                public Evidence() => throw null;
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

            // Generated from `System.Security.Policy.EvidenceBase` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public abstract class EvidenceBase
            {
                public virtual System.Security.Policy.EvidenceBase Clone() => throw null;
                protected EvidenceBase() => throw null;
            }

            // Generated from `System.Security.Policy.FileCodeGroup` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FileCodeGroup : System.Security.Policy.CodeGroup
            {
                public override string AttributeString { get => throw null; }
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                protected override void CreateXml(System.Security.SecurityElement element, System.Security.Policy.PolicyLevel level) => throw null;
                public override bool Equals(object o) => throw null;
                public FileCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Permissions.FileIOPermissionAccess access) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                public override int GetHashCode() => throw null;
                public override string MergeLogic { get => throw null; }
                protected override void ParseXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override string PermissionSetName { get => throw null; }
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }

            // Generated from `System.Security.Policy.FirstMatchCodeGroup` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class FirstMatchCodeGroup : System.Security.Policy.CodeGroup
            {
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                public FirstMatchCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Policy.PolicyStatement policy) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                public override string MergeLogic { get => throw null; }
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }

            // Generated from `System.Security.Policy.GacInstalled` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GacInstalled : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public override bool Equals(object o) => throw null;
                public GacInstalled() => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Policy.GacMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class GacMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public GacMembershipCondition() => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.Hash` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Hash : System.Security.Policy.EvidenceBase, System.Runtime.Serialization.ISerializable
            {
                public static System.Security.Policy.Hash CreateMD5(System.Byte[] md5) => throw null;
                public static System.Security.Policy.Hash CreateSHA1(System.Byte[] sha1) => throw null;
                public static System.Security.Policy.Hash CreateSHA256(System.Byte[] sha256) => throw null;
                public System.Byte[] GenerateHash(System.Security.Cryptography.HashAlgorithm hashAlg) => throw null;
                public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public Hash(System.Reflection.Assembly assembly) => throw null;
                public System.Byte[] MD5 { get => throw null; }
                public System.Byte[] SHA1 { get => throw null; }
                public System.Byte[] SHA256 { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Policy.HashMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class HashMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable, System.Runtime.Serialization.ISerializable, System.Runtime.Serialization.IDeserializationCallback
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                void System.Runtime.Serialization.ISerializable.GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                public System.Security.Cryptography.HashAlgorithm HashAlgorithm { get => throw null; set => throw null; }
                public HashMembershipCondition(System.Security.Cryptography.HashAlgorithm hashAlg, System.Byte[] value) => throw null;
                public System.Byte[] HashValue { get => throw null; set => throw null; }
                void System.Runtime.Serialization.IDeserializationCallback.OnDeserialization(object sender) => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.IIdentityPermissionFactory` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IIdentityPermissionFactory
            {
                System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence);
            }

            // Generated from `System.Security.Policy.IMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public interface IMembershipCondition : System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                bool Check(System.Security.Policy.Evidence evidence);
                System.Security.Policy.IMembershipCondition Copy();
                bool Equals(object obj);
                string ToString();
            }

            // Generated from `System.Security.Policy.NetCodeGroup` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class NetCodeGroup : System.Security.Policy.CodeGroup
            {
                public static string AbsentOriginScheme;
                public void AddConnectAccess(string originScheme, System.Security.Policy.CodeConnectAccess connectAccess) => throw null;
                public static string AnyOtherOriginScheme;
                public override string AttributeString { get => throw null; }
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                protected override void CreateXml(System.Security.SecurityElement element, System.Security.Policy.PolicyLevel level) => throw null;
                public override bool Equals(object o) => throw null;
                public System.Collections.DictionaryEntry[] GetConnectAccessRules() => throw null;
                public override int GetHashCode() => throw null;
                public override string MergeLogic { get => throw null; }
                public NetCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
                protected override void ParseXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public override string PermissionSetName { get => throw null; }
                public void ResetConnectAccess() => throw null;
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
            }

            // Generated from `System.Security.Policy.PermissionRequestEvidence` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PermissionRequestEvidence : System.Security.Policy.EvidenceBase
            {
                public System.Security.Policy.PermissionRequestEvidence Copy() => throw null;
                public System.Security.PermissionSet DeniedPermissions { get => throw null; }
                public System.Security.PermissionSet OptionalPermissions { get => throw null; }
                public PermissionRequestEvidence(System.Security.PermissionSet request, System.Security.PermissionSet optional, System.Security.PermissionSet denied) => throw null;
                public System.Security.PermissionSet RequestedPermissions { get => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Policy.PolicyException` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PolicyException : System.SystemException
            {
                public PolicyException(string message, System.Exception exception) => throw null;
                public PolicyException(string message) => throw null;
                public PolicyException() => throw null;
                protected PolicyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
            }

            // Generated from `System.Security.Policy.PolicyLevel` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PolicyLevel
            {
                public void AddFullTrustAssembly(System.Security.Policy.StrongNameMembershipCondition snMC) => throw null;
                public void AddFullTrustAssembly(System.Security.Policy.StrongName sn) => throw null;
                public void AddNamedPermissionSet(System.Security.NamedPermissionSet permSet) => throw null;
                public System.Security.NamedPermissionSet ChangeNamedPermissionSet(string name, System.Security.PermissionSet pSet) => throw null;
                public static System.Security.Policy.PolicyLevel CreateAppDomainLevel() => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public System.Collections.IList FullTrustAssemblies { get => throw null; }
                public System.Security.NamedPermissionSet GetNamedPermissionSet(string name) => throw null;
                public string Label { get => throw null; }
                public System.Collections.IList NamedPermissionSets { get => throw null; }
                public void Recover() => throw null;
                public void RemoveFullTrustAssembly(System.Security.Policy.StrongNameMembershipCondition snMC) => throw null;
                public void RemoveFullTrustAssembly(System.Security.Policy.StrongName sn) => throw null;
                public System.Security.NamedPermissionSet RemoveNamedPermissionSet(string name) => throw null;
                public System.Security.NamedPermissionSet RemoveNamedPermissionSet(System.Security.NamedPermissionSet permSet) => throw null;
                public void Reset() => throw null;
                public System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.CodeGroup RootCodeGroup { get => throw null; set => throw null; }
                public string StoreLocation { get => throw null; }
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Security.PolicyLevelType Type { get => throw null; }
            }

            // Generated from `System.Security.Policy.PolicyStatement` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PolicyStatement : System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public string AttributeString { get => throw null; }
                public System.Security.Policy.PolicyStatementAttribute Attributes { get => throw null; set => throw null; }
                public System.Security.Policy.PolicyStatement Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement et, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement et) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.PermissionSet PermissionSet { get => throw null; set => throw null; }
                public PolicyStatement(System.Security.PermissionSet permSet, System.Security.Policy.PolicyStatementAttribute attributes) => throw null;
                public PolicyStatement(System.Security.PermissionSet permSet) => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.PolicyStatementAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            [System.Flags]
            public enum PolicyStatementAttribute
            {
                All,
                Exclusive,
                LevelFinal,
                Nothing,
            }

            // Generated from `System.Security.Policy.Publisher` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Publisher : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; }
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public Publisher(System.Security.Cryptography.X509Certificates.X509Certificate cert) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Policy.PublisherMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class PublisherMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public System.Security.Cryptography.X509Certificates.X509Certificate Certificate { get => throw null; set => throw null; }
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public PublisherMembershipCondition(System.Security.Cryptography.X509Certificates.X509Certificate certificate) => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.Site` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Site : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public static System.Security.Policy.Site CreateFromUrl(string url) => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; }
                public Site(string name) => throw null;
                public override string ToString() => throw null;
            }

            // Generated from `System.Security.Policy.SiteMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class SiteMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public string Site { get => throw null; set => throw null; }
                public SiteMembershipCondition(string site) => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
            }

            // Generated from `System.Security.Policy.StrongName` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StrongName : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; }
                public System.Security.Permissions.StrongNamePublicKeyBlob PublicKey { get => throw null; }
                public StrongName(System.Security.Permissions.StrongNamePublicKeyBlob blob, string name, System.Version version) => throw null;
                public override string ToString() => throw null;
                public System.Version Version { get => throw null; }
            }

            // Generated from `System.Security.Policy.StrongNameMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class StrongNameMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public string Name { get => throw null; set => throw null; }
                public System.Security.Permissions.StrongNamePublicKeyBlob PublicKey { get => throw null; set => throw null; }
                public StrongNameMembershipCondition(System.Security.Permissions.StrongNamePublicKeyBlob blob, string name, System.Version version) => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public System.Version Version { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Policy.TrustManagerContext` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class TrustManagerContext
            {
                public virtual bool IgnorePersistedDecision { get => throw null; set => throw null; }
                public virtual bool KeepAlive { get => throw null; set => throw null; }
                public virtual bool NoPrompt { get => throw null; set => throw null; }
                public virtual bool Persist { get => throw null; set => throw null; }
                public virtual System.ApplicationIdentity PreviousApplicationIdentity { get => throw null; set => throw null; }
                public TrustManagerContext(System.Security.Policy.TrustManagerUIContext uiContext) => throw null;
                public TrustManagerContext() => throw null;
                public virtual System.Security.Policy.TrustManagerUIContext UIContext { get => throw null; set => throw null; }
            }

            // Generated from `System.Security.Policy.TrustManagerUIContext` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public enum TrustManagerUIContext
            {
                Install,
                Run,
                Upgrade,
            }

            // Generated from `System.Security.Policy.UnionCodeGroup` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UnionCodeGroup : System.Security.Policy.CodeGroup
            {
                public override System.Security.Policy.CodeGroup Copy() => throw null;
                public override string MergeLogic { get => throw null; }
                public override System.Security.Policy.PolicyStatement Resolve(System.Security.Policy.Evidence evidence) => throw null;
                public override System.Security.Policy.CodeGroup ResolveMatchingCodeGroups(System.Security.Policy.Evidence evidence) => throw null;
                public UnionCodeGroup(System.Security.Policy.IMembershipCondition membershipCondition, System.Security.Policy.PolicyStatement policy) : base(default(System.Security.Policy.IMembershipCondition), default(System.Security.Policy.PolicyStatement)) => throw null;
            }

            // Generated from `System.Security.Policy.Url` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Url : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public Url(string name) => throw null;
                public string Value { get => throw null; }
            }

            // Generated from `System.Security.Policy.UrlMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class UrlMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public string Url { get => throw null; set => throw null; }
                public UrlMembershipCondition(string url) => throw null;
            }

            // Generated from `System.Security.Policy.Zone` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class Zone : System.Security.Policy.EvidenceBase, System.Security.Policy.IIdentityPermissionFactory
            {
                public object Copy() => throw null;
                public static System.Security.Policy.Zone CreateFromUrl(string url) => throw null;
                public System.Security.IPermission CreateIdentityPermission(System.Security.Policy.Evidence evidence) => throw null;
                public override bool Equals(object o) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.SecurityZone SecurityZone { get => throw null; }
                public override string ToString() => throw null;
                public Zone(System.Security.SecurityZone zone) => throw null;
            }

            // Generated from `System.Security.Policy.ZoneMembershipCondition` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class ZoneMembershipCondition : System.Security.Policy.IMembershipCondition, System.Security.ISecurityPolicyEncodable, System.Security.ISecurityEncodable
            {
                public bool Check(System.Security.Policy.Evidence evidence) => throw null;
                public System.Security.Policy.IMembershipCondition Copy() => throw null;
                public override bool Equals(object o) => throw null;
                public void FromXml(System.Security.SecurityElement e, System.Security.Policy.PolicyLevel level) => throw null;
                public void FromXml(System.Security.SecurityElement e) => throw null;
                public override int GetHashCode() => throw null;
                public System.Security.SecurityZone SecurityZone { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public System.Security.SecurityElement ToXml(System.Security.Policy.PolicyLevel level) => throw null;
                public System.Security.SecurityElement ToXml() => throw null;
                public ZoneMembershipCondition(System.Security.SecurityZone zone) => throw null;
            }

        }
    }
    namespace ServiceProcess
    {
        // Generated from `System.ServiceProcess.ServiceControllerPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ServiceControllerPermission : System.Security.Permissions.ResourcePermissionBase
        {
            public System.ServiceProcess.ServiceControllerPermissionEntryCollection PermissionEntries { get => throw null; }
            public ServiceControllerPermission(System.ServiceProcess.ServiceControllerPermissionEntry[] permissionAccessEntries) => throw null;
            public ServiceControllerPermission(System.ServiceProcess.ServiceControllerPermissionAccess permissionAccess, string machineName, string serviceName) => throw null;
            public ServiceControllerPermission(System.Security.Permissions.PermissionState state) => throw null;
            public ServiceControllerPermission() => throw null;
        }

        // Generated from `System.ServiceProcess.ServiceControllerPermissionAccess` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        [System.Flags]
        public enum ServiceControllerPermissionAccess
        {
            Browse,
            Control,
            None,
        }

        // Generated from `System.ServiceProcess.ServiceControllerPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ServiceControllerPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public string MachineName { get => throw null; set => throw null; }
            public System.ServiceProcess.ServiceControllerPermissionAccess PermissionAccess { get => throw null; set => throw null; }
            public ServiceControllerPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public string ServiceName { get => throw null; set => throw null; }
        }

        // Generated from `System.ServiceProcess.ServiceControllerPermissionEntry` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ServiceControllerPermissionEntry
        {
            public string MachineName { get => throw null; }
            public System.ServiceProcess.ServiceControllerPermissionAccess PermissionAccess { get => throw null; }
            public ServiceControllerPermissionEntry(System.ServiceProcess.ServiceControllerPermissionAccess permissionAccess, string machineName, string serviceName) => throw null;
            public ServiceControllerPermissionEntry() => throw null;
            public string ServiceName { get => throw null; }
        }

        // Generated from `System.ServiceProcess.ServiceControllerPermissionEntryCollection` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class ServiceControllerPermissionEntryCollection : System.Collections.CollectionBase
        {
            public int Add(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public void AddRange(System.ServiceProcess.ServiceControllerPermissionEntry[] value) => throw null;
            public void AddRange(System.ServiceProcess.ServiceControllerPermissionEntryCollection value) => throw null;
            public bool Contains(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public void CopyTo(System.ServiceProcess.ServiceControllerPermissionEntry[] array, int index) => throw null;
            public int IndexOf(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public void Insert(int index, System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
            public System.ServiceProcess.ServiceControllerPermissionEntry this[int index] { get => throw null; set => throw null; }
            protected override void OnClear() => throw null;
            protected override void OnInsert(int index, object value) => throw null;
            protected override void OnRemove(int index, object value) => throw null;
            protected override void OnSet(int index, object oldValue, object newValue) => throw null;
            public void Remove(System.ServiceProcess.ServiceControllerPermissionEntry value) => throw null;
        }

    }
    namespace Transactions
    {
        // Generated from `System.Transactions.DistributedTransactionPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DistributedTransactionPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
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

        // Generated from `System.Transactions.DistributedTransactionPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class DistributedTransactionPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public override System.Security.IPermission CreatePermission() => throw null;
            public DistributedTransactionPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public bool Unrestricted { get => throw null; set => throw null; }
        }

    }
    namespace Web
    {
        // Generated from `System.Web.AspNetHostingPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class AspNetHostingPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
        {
            public AspNetHostingPermission(System.Web.AspNetHostingPermissionLevel level) => throw null;
            public AspNetHostingPermission(System.Security.Permissions.PermissionState state) => throw null;
            public override System.Security.IPermission Copy() => throw null;
            public override void FromXml(System.Security.SecurityElement securityElement) => throw null;
            public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
            public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
            public bool IsUnrestricted() => throw null;
            public System.Web.AspNetHostingPermissionLevel Level { get => throw null; set => throw null; }
            public override System.Security.SecurityElement ToXml() => throw null;
            public override System.Security.IPermission Union(System.Security.IPermission target) => throw null;
        }

        // Generated from `System.Web.AspNetHostingPermissionAttribute` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public class AspNetHostingPermissionAttribute : System.Security.Permissions.CodeAccessSecurityAttribute
        {
            public AspNetHostingPermissionAttribute(System.Security.Permissions.SecurityAction action) : base(default(System.Security.Permissions.SecurityAction)) => throw null;
            public override System.Security.IPermission CreatePermission() => throw null;
            public System.Web.AspNetHostingPermissionLevel Level { get => throw null; set => throw null; }
        }

        // Generated from `System.Web.AspNetHostingPermissionLevel` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
        public enum AspNetHostingPermissionLevel
        {
            High,
            Low,
            Medium,
            Minimal,
            None,
            Unrestricted,
        }

    }
    namespace Xaml
    {
        namespace Permissions
        {
            // Generated from `System.Xaml.Permissions.XamlLoadPermission` in `System.Security.Permissions, Version=5.0.0.0, Culture=neutral, PublicKeyToken=cc7b13ffcd2ddd51`
            public class XamlLoadPermission : System.Security.CodeAccessPermission, System.Security.Permissions.IUnrestrictedPermission
            {
                public System.Collections.Generic.IList<System.Xaml.Permissions.XamlAccessLevel> AllowedAccess { get => throw null; }
                public override System.Security.IPermission Copy() => throw null;
                public override bool Equals(object obj) => throw null;
                public override void FromXml(System.Security.SecurityElement elem) => throw null;
                public override int GetHashCode() => throw null;
                public bool Includes(System.Xaml.Permissions.XamlAccessLevel requestedAccess) => throw null;
                public override System.Security.IPermission Intersect(System.Security.IPermission target) => throw null;
                public override bool IsSubsetOf(System.Security.IPermission target) => throw null;
                public bool IsUnrestricted() => throw null;
                public override System.Security.SecurityElement ToXml() => throw null;
                public override System.Security.IPermission Union(System.Security.IPermission other) => throw null;
                public XamlLoadPermission(System.Xaml.Permissions.XamlAccessLevel allowedAccess) => throw null;
                public XamlLoadPermission(System.Security.Permissions.PermissionState state) => throw null;
                public XamlLoadPermission(System.Collections.Generic.IEnumerable<System.Xaml.Permissions.XamlAccessLevel> allowedAccess) => throw null;
            }

        }
    }
}
