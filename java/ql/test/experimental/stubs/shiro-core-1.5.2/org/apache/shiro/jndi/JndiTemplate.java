package org.apache.shiro.jndi;

import javax.naming.NamingException;

public class JndiTemplate {
  public Object lookup(final String name) throws NamingException {
    return new Object();
  }
  
  public Object lookup(String name, Class requiredType) throws NamingException {
    return new Object();
  }
}