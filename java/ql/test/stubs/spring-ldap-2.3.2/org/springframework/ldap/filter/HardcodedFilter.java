package org.springframework.ldap.filter;

public class HardcodedFilter implements Filter {
  public HardcodedFilter(String filter) { }
  public StringBuffer encode(StringBuffer buff) { return buff; }
  public String toString() { return ""; }
}
