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
            // Generated from `System.Data.Common.DbConnectionStringBuilder` in `System.Data, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`
            public class DbConnectionStringBuilder : System.Collections.IEnumerable, System.Collections.IDictionary, System.Collections.ICollection
            {
                System.Collections.IDictionaryEnumerator System.Collections.IDictionary.GetEnumerator() => throw null;
                System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                bool System.Collections.ICollection.IsSynchronized { get => throw null; }
                bool System.Collections.IDictionary.Contains(object keyword) => throw null;
                object System.Collections.ICollection.SyncRoot { get => throw null; }
                public object this[object keyword] { get => throw null; set => throw null; }
                public bool IsReadOnly { get => throw null; }
                public override string ToString() => throw null;
                public string ConnectionString { get => throw null; set => throw null; }
                public virtual System.Collections.ICollection Keys { get => throw null; }
                public virtual System.Collections.ICollection Values { get => throw null; }
                public virtual bool IsFixedSize { get => throw null; }
                public virtual int Count { get => throw null; }
                public virtual void Clear() => throw null;
                void System.Collections.ICollection.CopyTo(System.Array array, int index) => throw null;
                void System.Collections.IDictionary.Add(object keyword, object value) => throw null;
                void System.Collections.IDictionary.Remove(object keyword) => throw null;
                public void Dispose() => throw null;
            }

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
