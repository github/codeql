using NHibernate;
using NHibernate.SqlCommand;

namespace NHibernateTest
{
    class Test
    {
        ISession session;

        void SqlExprs()
        {
            var sql = "sql";
            new SqlString(sql); // SQL expression
            session.Delete(sql);  // SQL expression
        }

        class Person
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Address { get; set; }
        }

        class Person2
        {
            public int Id { get; set; }
            public int Age { get; set; }
            public string Address { get; set; }
        }

        void FlowSources()
        {
            session.Query<Person>();
            session.Save(new Person2());
        }

        void DataFlow()
        {
            var p = new Person();
            var p2 = new Person2();

            string taint = "tainted";
            p.Name = taint;
            p2.Address = taint;

            Sink(p.Id);  // Not tainted
            Sink(p.Name); // Tainted
            Sink(p.Address);  // Not tainted

            Sink(p2.Id); // Not tainted
            Sink(p2.Age);  // Not tainted
            Sink(p2.Address);  // Tainted
        }

        void Sink(object sink)
        {
        }
    }
}
