package org.hibernate;

import org.hibernate.query.Query;
import org.hibernate.query.QueryProducer;

public interface SharedSessionContract extends QueryProducer {

  Query createQuery(String queryString);

  Query createSQLQuery(String queryString);
}
