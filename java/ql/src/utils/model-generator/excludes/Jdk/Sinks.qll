private import java

bindingset[sink]
predicate isExcludedSink(string sink) {
  sink =
    [
      // These are too generic, and could result in too many false positives
      "java.lang;System;false;setProperties;(Properties);;Argument[0];jndi-injection;generated",
      "java.lang;System;false;setProperties;(Properties);;Argument[0];ldap;generated",
      "java.lang;System;false;setProperties;(Properties);;Argument[0];open-url;generated",
      // The paths for the below use an unreachable anonymous object
      "java.nio.file;Files;false;walkFileTree;(Path,FileVisitor);;Argument[0];open-url;generated",
      "java.nio.file;Files;false;walkFileTree;(Path,Set,int,FileVisitor);;Argument[0];open-url;generated",
      // The paths for the below all go through the same method, which doesn't seem to be exploitable
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
      "javax.naming.directory;InitialDirContext;true;InitialDirContext;(Hashtable);;Argument[0];jndi-injection;generated",
      "javax.naming.ldap;InitialLdapContext;true;InitialLdapContext;(Hashtable,Control[]);;Argument[0];jndi-injection;generated",
      "javax.naming.ldap;InitialLdapContext;true;InitialLdapContext;(Hashtable,Control[]);;Argument[1];jndi-injection;generated",
      "javax.naming.spi;NamingManager;true;getInitialContext;(Hashtable);;Argument[0];jndi-injection;generated",
      "javax.naming;InitialContext;true;InitialContext;(Hashtable);;Argument[0];jndi-injection;generated",
    ]
}
