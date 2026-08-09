package org.hibernate;

import org.hibernate.query.Query;

public interface Session extends SharedSessionContract {

  Query createQuery(String queryString);

  Query createSQLQuery(String queryString);
}
