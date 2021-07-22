// This file contains auto-generated code.
// original-extractor-options: /r:Dapper.dll /r:System.Data.SqlClient.dll ...

namespace Dapper
{
    // Generated from `Dapper.CommandDefinition` in `Dapper, Version=2.0.0.0, Culture=neutral, PublicKeyToken=null`
    public struct CommandDefinition
    {
        public CommandDefinition(string commandText, object parameters = null, System.Data.IDbTransaction transaction = null, int? commandTimeout = null, System.Data.CommandType? commandType = null, Dapper.CommandFlags flags = CommandFlags.Buffered, System.Threading.CancellationToken cancellationToken = default) => throw null;
    }

    // Generated from `Dapper.CommandFlags` in `Dapper, Version=2.0.0.0, Culture=neutral, PublicKeyToken=null`
    [System.Flags]
    public enum CommandFlags
    {
        None = 0x0,
        Buffered = 0x1,
        Pipelined = 0x2,
        NoCache = 0x4
    }

    // Generated from `Dapper.SqlMapper` in `Dapper, Version=2.0.0.0, Culture=neutral, PublicKeyToken=null`
    static public class SqlMapper
    {
        public static System.Collections.Generic.IEnumerable<T> Query<T>(this System.Data.IDbConnection cnn, string sql, object param = null, System.Data.IDbTransaction transaction = null, bool buffered = true, int? commandTimeout = null, System.Data.CommandType? commandType = null) => throw null;
        public static System.Data.IDataReader ExecuteReader(this System.Data.IDbConnection cnn, string sql, object param = null, System.Data.IDbTransaction transaction = null, int? commandTimeout = null, System.Data.CommandType? commandType = null) => throw null;
        public static System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<T>> QueryAsync<T>(this System.Data.IDbConnection cnn, string sql, object param = null, System.Data.IDbTransaction transaction = null, int? commandTimeout = null, System.Data.CommandType? commandType = null) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QueryFirstAsync(this System.Data.IDbConnection cnn, Dapper.CommandDefinition command) => throw null;
        public static System.Threading.Tasks.Task<dynamic> QueryFirstAsync(this System.Data.IDbConnection cnn, string sql, object param = null, System.Data.IDbTransaction transaction = null, int? commandTimeout = null, System.Data.CommandType? commandType = null) => throw null;
        public static System.Threading.Tasks.Task<int> ExecuteAsync(this System.Data.IDbConnection cnn, string sql, object param = null, System.Data.IDbTransaction transaction = null, int? commandTimeout = null, System.Data.CommandType? commandType = null) => throw null;
        public static object ExecuteScalar(this System.Data.IDbConnection cnn, string sql, object param = null, System.Data.IDbTransaction transaction = null, int? commandTimeout = null, System.Data.CommandType? commandType = null) => throw null;
    }
}

