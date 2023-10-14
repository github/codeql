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

    public class DbSet<TEntity> : IEnumerable<TEntity>
    {
        public void Add(TEntity t) { }
        public void AddRange(IEnumerable<TEntity> t) { }
        public void Attach(TEntity t) { }
        IEnumerator<TEntity> IEnumerable<TEntity>.GetEnumerator() => null;
        IEnumerator IEnumerable.GetEnumerator() => null;
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
        public int SaveChanges() => 0;
        public System.Threading.Tasks.Task<int> SaveChangesAsync() => null;
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
    public class DbSet<TEntity> : IEnumerable<TEntity>
    {
        public void Add(TEntity t) { }
        public System.Threading.Tasks.Task<int> AddAsync(TEntity t, System.Threading.CancellationToken ct = default) => null;
        public void AddRange(IEnumerable<TEntity> t) { }
        public void AddRange(TEntity[] t) { }
        public System.Threading.Tasks.Task<int> AddRangeAsync(IEnumerable<TEntity> t, System.Threading.CancellationToken ct = default) => null;
        public System.Threading.Tasks.Task<int> AddRangeAsync(TEntity[] t) => null;
        public void Attach(TEntity t) { }
        public void AttachRange(IEnumerable<TEntity> t) { }
        public void AttachRange(TEntity[] t) { }
        public void Update(TEntity t) { }
        public void UpdateRange(IEnumerable<TEntity> t) { }
        public void UpdateRange(TEntity[] t) { }

        IEnumerator<TEntity> IEnumerable<TEntity>.GetEnumerator() => null;
        IEnumerator IEnumerable.GetEnumerator() => null;
    }

    public class DbContext : IDisposable
    {
        public void Dispose() { }
        public virtual Infrastructure.DatabaseFacade Database => null;
        public int SaveChanges() => 0;
        public System.Threading.Tasks.Task<int> SaveChangesAsync() => null;
    }

    namespace Infrastructure
    {
        public class DatabaseFacade
        {
        }
    }

    public static class RelationalDatabaseFacadeExtensions
    {
        public static void ExecuteSqlCommand(this Infrastructure.DatabaseFacade db, string sql, params object[] parameters) { }
        public static Task ExecuteSqlCommandAsync(this Infrastructure.DatabaseFacade db, string sql, params object[] parameters) => throw null;

        public static int ExecuteSqlRaw(this Infrastructure.DatabaseFacade db, string sql, IEnumerable<object> args) => throw null;
        public static int ExecuteSqlRaw(this Infrastructure.DatabaseFacade db, string sql, params object[] args) => throw null;
        public static Task<int> ExecuteSqlRawAsync(this Infrastructure.DatabaseFacade db, string sql, System.Threading.CancellationToken token) => throw null;
        public static Task<int> ExecuteSqlRawAsync(this Infrastructure.DatabaseFacade db, string sql, params object[] args) => throw null;
        public static Task<int> ExecuteSqlRawAsync(this Infrastructure.DatabaseFacade db, string sql, IEnumerable<object> args, System.Threading.CancellationToken token) => throw null;
    }

    struct RawSqlString
    {
        public RawSqlString(string str) { }
        public static implicit operator Microsoft.EntityFrameworkCore.RawSqlString(FormattableString fs) => throw null;
        public static implicit operator Microsoft.EntityFrameworkCore.RawSqlString(string s) => throw null;
    }

    public static class RelationalQueryableExtensions
    {
        public static void FromSqlRaw<TEntity>(this DbSet<TEntity> set, string sql, params object[] args) => throw null;
    }
}

namespace Microsoft.EntityFrameworkCore.Storage
{
    interface IRawSqlCommandBuilder
    {
        void Build(string sql);
    }
}
