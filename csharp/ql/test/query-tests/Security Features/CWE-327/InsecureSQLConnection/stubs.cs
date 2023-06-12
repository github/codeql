// This file contains auto-generated code.

namespace System
{
    namespace Data
    {
        // Generated from `System.Data.IDbConnection` in `System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
        public interface IDbConnection : System.IDisposable
        {
            string ConnectionString { get; set; }
        }

        namespace Common
        {
            // Generated from `System.Data.Common.DbConnection` in `System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            abstract public class DbConnection : System.IDisposable, System.Data.IDbConnection
            {
                public abstract string ConnectionString { get; set; }
                public void Dispose() => throw null;
            }

        }
        namespace SqlClient
        {
            // Generated from `System.Data.SqlClient.SqlConnectionStringBuilder` in `System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class SqlConnectionStringBuilder : System.Data.Common.DbConnectionStringBuilder
            {
                public SqlConnectionStringBuilder() => throw null;
                public SqlConnectionStringBuilder(string connectionString) => throw null;
                public bool Encrypt { get => throw null; set => throw null; }
                public override System.Collections.ICollection Keys { get => throw null; }
                public override System.Collections.ICollection Values { get => throw null; }
                public override bool IsFixedSize { get => throw null; }
                public override void Clear() => throw null;
            }

            // Generated from `System.Data.SqlClient.SqlConnection` in `System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class SqlConnection : System.Data.Common.DbConnection, System.ICloneable
            {
                object System.ICloneable.Clone() => throw null;
                public SqlConnection() => throw null;
                public SqlConnection(string connectionString) => throw null;
                public override string ConnectionString { get => throw null; set => throw null; }
            }

        }
    }
}
