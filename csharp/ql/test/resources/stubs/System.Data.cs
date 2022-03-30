using System;

namespace System.Data.SqlClient
{

    public class SqlConnection : Common.DbConnection, IDisposable
    {
        public SqlConnection() { }
        public SqlConnection(string connectionString) { }
        public void Dispose() { }
        public override string ConnectionString { get; set; }
        public override void Open() { }
        public override void Close() { }
    }

    public class SqlCommand : Common.DbCommand
    {
        public SqlCommand(string s) { }
        public SqlCommand(string s, SqlConnection t) { }
        public SqlDataReader ExecuteReader() => null;
    }

    public class SqlDataReader : Common.DbDataReader, IDataReader, IDataRecord
    {
        public override string GetString(int i) => "";
    }

    public class SqlDataAdapter : Common.DbDataAdapter, IDbDataAdapter, IDataAdapter
    {
        public SqlDataAdapter(string a, SqlConnection b) { }
        public void Fill(DataSet ds) { }
        public SqlCommand SelectCommand { get; set; }
    }

    public class SqlParameter : Common.DbParameter, IDbDataParameter, IDataParameter
    {
        public SqlParameter(string s, object o) { }
    }

    public class SqlParameterCollection : Common.DbParameterCollection
    {
    }

    public class SqlConnectionStringBuilder : Common.DbConnectionStringBuilder
    {
    }

    public class SqlException : Common.DbException
    {
    }
}

namespace System.Data
{
    public interface IDbDataParameter
    {
    }

    public interface IDbConnection
    {
        string ConnectionString { get; set; }
    }

    public interface IDataRecord
    {
        string GetString(int i);
    }

    public interface IDbCommand
    {
        IDataReader ExecuteReader();
        CommandType CommandType { get; set; }
        IDataParameterCollection Parameters { get; set; }
        string CommandText { get; set; }
    }

    public interface IDataReader
    {
        bool Read();
        void Close();
        string GetString(int i);
    }


    public interface IDataAdapter
    {
    }

    public interface IDbDataAdapter
    {
    }

    public interface IDataParameter
    {
    }

    public interface IDataParameterCollection
    {
        void Add(object obj);
    }
}

namespace System.Data.Common
{

    public abstract class DbConnection : IDbConnection
    {
        public virtual string ConnectionString { get; set; }
        string IDbConnection.ConnectionString { get; set; }
        public abstract void Open();
        public abstract void Close();
    }

    public class DbDataReader : IDataReader
    {
        public bool Read() => false;
        public void Close() { }
        public virtual string GetString(int i) => "";
    }

    public abstract class DbCommand : IDbCommand, IDisposable
    {
        public DbDataReader ExecuteReader() => null;
        public CommandType CommandType { get; set; }
        public IDataParameterCollection Parameters { get; set; }
        IDataReader IDbCommand.ExecuteReader() => null;
        public void Dispose() { }
        public string CommandText { get; set; }
    }

    public class DbDataAdapter : IDataAdapter, IDbDataAdapter
    {
    }

    public class DbParameter : IDbDataParameter, IDataParameter
    {
    }

    public class DbParameterCollection : IDataParameterCollection
    {
        public void Add(object obj) { }
    }

    public class DbConnectionStringBuilder
    {
        public virtual object this[string keyword] { get => null; set { } }
        public virtual string ConnectionString { get; set; }
    }

    public class DbException : Exception
    {
    }
}

namespace System.Data.OleDb
{

    public class OleDbConnection : Common.DbConnection, IDisposable
    {
        public OleDbConnection(string s) { }
        void IDisposable.Dispose() { }
        public override void Open() { }
        public override void Close() { }
    }

    public class OleDbDataReader : Common.DbDataReader
    {
        public bool Read() => false;
        public void Close()
        {
        }

        public string GetString(int x) => null;

        public object this[string s] => null;
    }

    public class OleDbCommand : Common.DbCommand
    {
        public OleDbCommand(string e, OleDbConnection c)
        {
        }

        public OleDbDataReader ExecuteReader() => null;
    }
}

