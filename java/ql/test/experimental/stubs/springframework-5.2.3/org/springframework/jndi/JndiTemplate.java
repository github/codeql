package org.springframework.jndi;

import java.util.Properties;
import javax.naming.NamingException;

public class JndiTemplate {
	public JndiTemplate() {}

	public JndiTemplate(Properties environment) {}

  public Object lookup(final String name) throws NamingException {
		return new Object();
	}

	@SuppressWarnings("unchecked")
	public <T> T lookup(String name, Class<T> requiredType) throws NamingException {
		return (T) new Object();
	}
	
	public void setEnvironment(Properties environment) {}
}
