package org.springframework.ldap.query;

import javax.naming.Name;
import org.springframework.ldap.filter.Filter;

public class LdapQueryBuilder {
  public static LdapQueryBuilder query() { return null; }
  public LdapQuery filter(String hardcodedFilter) { return null; }
  public LdapQuery filter(Filter filter) { return null; }
  public LdapQuery filter(String filterFormat, Object... params) { return null; }
  public LdapQueryBuilder base(String baseDn) { return this; }
  public Name base() { return null; }
  public ConditionCriteria where(String attribute) { return null; }
}
