using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;
using System.Threading.Tasks;
using System;

namespace System.Data.Entity
{
    public class DbSet
    {
    }

    public class DbSet<T>
    {
    }

    public class Database
    {
        public int ExecuteSqlQuery(string sql, params object[] parameters) => 0;
        public int ExecuteSqlCommand(string sql, params object[] parameters) => 0;
        public async Task ExecuteSqlCommandAsync(string sql, params object[] parameters) => throw null;
        public Infrastructure.DbRawSqlQuery<T> SqlQuery<T>(string sql, params object[] parameters) => null;
    }

    public class DbContext : IDisposable
    {
        public void Dispose() { }
        public Database Database => null;
        public Infrastructure.DbRawSqlQuery<TElement> SqlQuery<TElement>(string sql, params object[] parameters) => null;
    }
}

namespace System.Data.Entity.Infrastructure
{
    interface IDbAsyncEnumerable
    {
    }

    public class DbRawSqlQuery<T> : IEnumerable<T>, IListSource, IDbAsyncEnumerable
    {
        IEnumerator<T> IEnumerable<T>.GetEnumerator() => null;
        IEnumerator IEnumerable.GetEnumerator() => null;
        bool IListSource.ContainsListCollection => false;
        IList IListSource.GetList() => null;
    }
}

namespace Microsoft.EntityFrameworkCore
{
    public class DbSet<T>
    {
    }

    public class DbContext : IDisposable
    {
        public void Dispose() { }
        public virtual Infrastructure.DatabaseFacade Database => null;
        // public Infrastructure.DbRawSqlQuery<TElement> SqlQuery<TElement>(string sql, params object[] parameters) => null;
    }

    namespace Infrastructure
    {
      public class DatabaseFacade
      {
      }
    }

    public static class RelationalDatabaseFacaseExtensions
    {
      public static void ExecuteSqlCommand(this Infrastructure.DatabaseFacade db, string sql, params object[] parameters) {}
      public static Task ExecuteSqlCommandAsync(this Infrastructure.DatabaseFacade db, string sql, params object[] parameters) => throw null;
    }

    struct RawSqlString
    {
        public RawSqlString(string str) { }
        public static implicit operator Microsoft.EntityFrameworkCore.RawSqlString (FormattableString fs) => throw null;
        public static implicit operator Microsoft.EntityFrameworkCore.RawSqlString (string s) => throw null;
    }
}

namespace System.ComponentModel.DataAnnotations.Schema
{
    class NotMappedAttribute : Attribute
    {
    }
}

namespace Microsoft.EntityFrameworkCore.Storage
{
    interface IRawSqlCommandBuilder
    {
        void Build(string sql);
    }
}
