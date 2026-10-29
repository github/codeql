package org.hibernate.query;

public interface QueryProducer {

  Query createNativeQuery(String sqlString);

  MutationQuery createNativeMutationQuery(String sqlString);

  Query createQuery(String queryString);

  MutationQuery createMutationQuery(String hqlString);

  SelectionQuery<?> createSelectionQuery(String hqlString);

  <R> SelectionQuery<R> createSelectionQuery(String hqlString, Class<R> resultType);

  Query createSQLQuery(String queryString);
}
