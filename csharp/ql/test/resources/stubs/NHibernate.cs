
namespace NHibernate
{
    public interface ISession
    {
        void Delete(string query);
        T Query<T>();
        void Save(object obj);
    }

    namespace SqlCommand
    {
        public class SqlString
        {
            public SqlString(string sql) { }
        }
    }
}
