package org.springframework.ldap.filter;

public class HardcodedFilter implements Filter {
  public HardcodedFilter(String filter) { }
  public String encode() { return null; }
  public StringBuffer encode(StringBuffer buff) { return buff; }
  public String toString() { return ""; }
  public boolean equals(Object p0) { return false; }
  public int hashCode() { return 0; }
}
