using System;

namespace TestNHibernate
{
    using System.Data;
    using System.IO;
    using System.Text;
    using System.Web.UI.WebControls;

    class SqlInjection
    {
        private string connectionString;
        public TextBox untrustedData;

        public void InjectUntrustedData(NHibernate.ISession session, NHibernate.IStatelessSession statelessSession, NHibernate.Impl.AbstractSessionImpl impl)
        {
            session.CreateSQLQuery(untrustedData.Text); // $ Alert[cs/sql-injection]

            statelessSession.CreateSQLQuery(untrustedData.Text); // $ Alert[cs/sql-injection]

            impl.CreateSQLQuery(untrustedData.Text); // $ Alert[cs/sql-injection]
        }
    }
}
