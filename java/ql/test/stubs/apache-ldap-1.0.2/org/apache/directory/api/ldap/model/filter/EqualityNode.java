package org.apache.directory.api.ldap.model.filter;

import org.apache.directory.api.ldap.model.entry.Value;

public class EqualityNode<T> implements ExprNode {
  public EqualityNode(String attribute, Value<T> value) { }
  public EqualityNode(String attribute, String value) { }
}
