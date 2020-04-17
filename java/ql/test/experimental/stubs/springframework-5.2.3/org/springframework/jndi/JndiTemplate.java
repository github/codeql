package org.springframework.jndi;

import javax.naming.NamingException;

public class JndiTemplate {
  public Object lookup(final String name) throws NamingException {
		return new Object();
	}

	@SuppressWarnings("unchecked")
	public <T> T lookup(String name, Class<T> requiredType) throws NamingException {
		return (T) new Object();
  }
}
