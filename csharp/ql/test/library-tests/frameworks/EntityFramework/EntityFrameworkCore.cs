using Microsoft.EntityFrameworkCore;
using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Common;

namespace EFCoreTests
{
    class Person
    {
      public int Id { get; set; }
      public string Name { get; set; }
    
      [NotMapped]
      public int Age { get; set; }
    }

    class MyContext : DbContext
    {
        DbSet<Person> person;

        void FlowSources()
        {
            var p = new Person();
            var id = p.Id;  // Remote flow source
            var name = p.Name;  // Remote flow source
            var age = p.Age;  // Not a remote flow source
        }

        Microsoft.EntityFrameworkCore.Storage.IRawSqlCommandBuilder builder;

        async void SqlExprs()
        {
            // Microsoft.EntityFrameworkCore.RelationalDatabaseFacadeExtensions.ExecuteSqlCommand
            this.Database.ExecuteSqlCommand("");  // SqlExpr
            await this.Database.ExecuteSqlCommandAsync("");  // SqlExpr

            // Microsoft.EntityFrameworkCore.Storage.IRawSqlCommandBuilder.Build
            builder.Build("");  // SqlExpr

            // Microsoft.EntityFrameworkCore.RawSqlString
            new RawSqlString("");  // SqlExpr
            RawSqlString str = "";  // SqlExpr
        }

        void TestDataFlow()
        {
            var taintSource = "tainted";
            var untaintedSource = "untainted";

            Sink(taintSource);  // Tainted
            Sink(new RawSqlString(taintSource));  // Tainted
            Sink((RawSqlString)taintSource);  // Tainted
            Sink((RawSqlString)(FormattableString)$"{taintSource}");  // Tainted

            // Tainted via database, even though technically there were no reads or writes to the database in this particular case.
            var p1 = new Person { Name = taintSource };
            p1.Name = untaintedSource;
            var p2 = new Person();

            Sink(p2.Name);  // Tainted
            Sink(new Person().Name);  // Tainted

            p1.Age = int.Parse(taintSource);
            Sink(p2.Age);  // Not tainted due to NotMappedAttribute
        }

        void Sink(object @object)
        {
        }
    }
}
