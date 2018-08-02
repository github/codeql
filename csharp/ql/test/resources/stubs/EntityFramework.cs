using System.Collections.Generic;
using System.Collections;
using System.ComponentModel;

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
