// semmle-extractor-options: /r:System.Data.dll /r:System.ComponentModel.Primitives.dll /r:System.ComponentModel.TypeConverter.dll ${testdir}/../../../resources/stubs/EntityFramework.cs ${testdir}/../../../resources/stubs/System.Data.cs /r:System.ComponentModel.TypeConverter.dll /r:System.Data.Common.dll

using System.Data.Entity;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data;
using System.Data.Common;

namespace EFTests
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
        DbSet<Person> person { get; set; }

        void FlowSources()
        {
            var p = new Person();
            var id = p.Id;  // Remote flow source
            var name = p.Name;  // Remote flow source
            var age = p.Age;  // Not a remote flow source
        }

        DbCommand command;

        async void SqlSinks()
        {
            // System.Data.Common.DbCommand.set_CommandText
            command.CommandText = "";  // SqlExpr

            // System.Data.SqlClient.SqlCommand.SqlCommand
            new System.Data.SqlClient.SqlCommand("");  // SqlExpr

            this.Database.ExecuteSqlCommand("");  // SqlExpr
            await this.Database.ExecuteSqlCommandAsync("");  // SqlExpr
        }

        void TestDataFlow()
        {
            string taintSource = "tainted";

            // Tainted via database, even though technically there were no reads or writes to the database in this particular case.
            var p1 = new Person { Name = taintSource };
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