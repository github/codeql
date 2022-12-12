private import java

bindingset[sink]
predicate isExcludedSink(string sink) {
  sink =
    [
      // These are too generic, and could result in too many false positives
      // - JDK 11
      "java.lang;System;false;setProperties;(Properties);;Argument[0];jndi-injection;generated",
      "java.lang;System;false;setProperties;(Properties);;Argument[0];ldap;generated",
      "java.lang;System;false;setProperties;(Properties);;Argument[0];open-url;generated",
      // - JDK 12
      "java.net;CookieHandler;true;setDefault;(CookieHandler);;Argument[0];jndi-injection;generated",
      "java.net;CookieHandler;true;setDefault;(CookieHandler);;Argument[0];ldap;generated",
      "java.net;CookieHandler;true;setDefault;(CookieHandler);;Argument[0];open-url;generated",
      "java.net;ProxySelector;true;setDefault;(ProxySelector);;Argument[0];jndi-injection;generated",
      "java.net;ProxySelector;true;setDefault;(ProxySelector);;Argument[0];ldap;generated",
      "java.net;ProxySelector;true;setDefault;(ProxySelector);;Argument[0];open-url;generated",
      "java.net;ResponseCache;true;setDefault;(ResponseCache);;Argument[0];jndi-injection;generated",
      "java.net;ResponseCache;true;setDefault;(ResponseCache);;Argument[0];ldap;generated",
      "java.net;ResponseCache;true;setDefault;(ResponseCache);;Argument[0];open-url;generated",
      "java.security;Policy;true;setPolicy;(Policy);;Argument[0];jndi-injection;generated",
      "java.security;Policy;true;setPolicy;(Policy);;Argument[0];ldap;generated",
      "java.security;Policy;true;setPolicy;(Policy);;Argument[0];open-url;generated",
      "javax.security.auth.login;Configuration;true;setConfiguration;(Configuration);;Argument[0];jndi-injection;generated",
      "javax.security.auth.login;Configuration;true;setConfiguration;(Configuration);;Argument[0];ldap;generated",
      "javax.security.auth.login;Configuration;true;setConfiguration;(Configuration);;Argument[0];open-url;generated",
      // - JDK 17
      "java.util;Locale;false;setDefault;(Category,Locale);;Argument[1];jndi-injection;generated",
      "java.util;Locale;false;setDefault;(Category,Locale);;Argument[1];ldap;generated",
      "java.util;Locale;false;setDefault;(Category,Locale);;Argument[1];open-url;generated",
      "java.util;Locale;false;setDefault;(Locale);;Argument[0];jndi-injection;generated",
      "java.util;Locale;false;setDefault;(Locale);;Argument[0];ldap;generated",
      "java.util;Locale;false;setDefault;(Locale);;Argument[0];open-url;generated",
      // The paths for the below use an unreachable anonymous object
      // - JDK 11
      "java.nio.file;Files;false;walkFileTree;(Path,FileVisitor);;Argument[0];open-url;generated",
      "java.nio.file;Files;false;walkFileTree;(Path,Set,int,FileVisitor);;Argument[0];open-url;generated",
      // The paths for the below all go through the same method, which doesn't seem to be exploitable
      // - JDK 11
      "javax.naming.directory;DirContext;true;bind;(Name,Object,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;bind;(String,Object,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;createSubcontext;(Name,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;createSubcontext;(String,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getAttributes;(Name);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getAttributes;(Name,String[]);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getAttributes;(String);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getAttributes;(String,String[]);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getSchema;(Name);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getSchema;(String);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getSchemaClassDefinition;(Name);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;getSchemaClassDefinition;(String);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;modifyAttributes;(Name,ModificationItem[]);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;modifyAttributes;(Name,int,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;modifyAttributes;(String,ModificationItem[]);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;modifyAttributes;(String,int,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;rebind;(Name,Object,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;rebind;(String,Object,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(Name,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(Name,Attributes,String[]);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(Name,String,Object[],SearchControls);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(Name,String,SearchControls);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(String,Attributes);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(String,Attributes,String[]);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(String,String,Object[],SearchControls);;Argument[0];jndi-injection;generated",
      "javax.naming.directory;DirContext;true;search;(String,String,SearchControls);;Argument[0];jndi-injection;generated",
      // The below are exploitable if `java.naming.provider.url` is set, but that's already handled.
      // - JDK 11
      "javax.naming.directory;InitialDirContext;true;InitialDirContext;(Hashtable);;Argument[0];jndi-injection;generated",
      "javax.naming.ldap;InitialLdapContext;true;InitialLdapContext;(Hashtable,Control[]);;Argument[0];jndi-injection;generated",
      "javax.naming.ldap;InitialLdapContext;true;InitialLdapContext;(Hashtable,Control[]);;Argument[1];jndi-injection;generated",
      "javax.naming.spi;NamingManager;true;getInitialContext;(Hashtable);;Argument[0];jndi-injection;generated",
      "javax.naming;InitialContext;true;InitialContext;(Hashtable);;Argument[0];jndi-injection;generated",
      // - JDK 10
      "javax.naming.directory;InitialDirContext;true;InitialDirContext;(Hashtable);;Argument[0];open-url;generated",
      "javax.naming.ldap;InitialLdapContext;true;InitialLdapContext;(Hashtable,Control[]);;Argument[0];open-url;generated",
      "javax.naming.ldap;InitialLdapContext;true;InitialLdapContext;(Hashtable,Control[]);;Argument[1];open-url;generated",
      "javax.naming.spi;NamingManager;true;getInitialContext;(Hashtable);;Argument[0];open-url;generated",
      "javax.naming;InitialContext;true;InitialContext;(Hashtable);;Argument[0];open-url;generated",
      // Should only apply to DirContext:
      "javax.naming;Context;true;list;(Name);;Argument[0];ldap;generated",
      "javax.naming;Context;true;listBindings;(Name);;Argument[0];ldap;generated",
      // Should be restricted to those cases where the attacker can control the provider url:
      "javax.naming;Context;true;addToEnvironment;(String,Object);;Argument[1];jndi-injection;generated",
      "javax.naming;Context;true;addToEnvironment;(String,Object);;Argument[1];open-url;generated",
      // Should apply to URLDataSource and it has an impact on DataContentHandler and DataContent sinks:
      "javax.activation;DataSource;true;getContentType;();;Argument[-1];open-url;generated",
      "javax.activation;DataSource;true;getInputStream;();;Argument[-1];open-url;generated",
      "javax.activation;DataSource;true;getOutputStream;();;Argument[-1];open-url;generated"
    ]
}
