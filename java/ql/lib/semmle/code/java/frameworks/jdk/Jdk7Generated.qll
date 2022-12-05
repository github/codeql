/**
 * THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.
 * Definitions of taint steps in the Java JDK 7 framework.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class Jdk7GeneratedSinksCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "java.applet;Applet;true;getAudioClip;(URL);;Argument[0];open-url;generated",
        "java.applet;Applet;true;getAudioClip;(URL,String);;Argument[1];open-url;generated",
        "java.applet;Applet;true;getImage;(URL);;Argument[0];open-url;generated",
        "java.applet;Applet;true;getImage;(URL,String);;Argument[1];open-url;generated",
        "java.applet;Applet;true;newAudioClip;(URL);;Argument[0];open-url;generated",
        "java.applet;Applet;true;play;(URL);;Argument[0];open-url;generated",
        "java.applet;Applet;true;play;(URL,String);;Argument[1];open-url;generated",
        "java.applet;AppletContext;true;getAudioClip;(URL);;Argument[0];open-url;generated",
        "java.applet;AppletContext;true;getImage;(URL);;Argument[0];open-url;generated",
        "java.net;URL;false;getContent;();;Argument[-1];open-url;generated",
        "java.net;URL;false;getContent;(Class[]);;Argument[-1];open-url;generated",
        "java.rmi.server;RMIClassLoader;true;getClassLoader;(String);;Argument[0];open-url;generated",
        "java.rmi.server;RMIClassLoader;true;loadClass;(String,String);;Argument[0];open-url;generated",
        "java.rmi.server;RMIClassLoader;true;loadClass;(String,String,ClassLoader);;Argument[0];open-url;generated",
        "java.rmi.server;RMIClassLoader;true;loadProxyClass;(String,String[],ClassLoader);;Argument[0];open-url;generated",
        "java.rmi.server;RMIClassLoaderSpi;true;getClassLoader;(String);;Argument[0];open-url;generated",
        "java.rmi.server;RMIClassLoaderSpi;true;loadClass;(String,String,ClassLoader);;Argument[0];open-url;generated",
        "java.rmi.server;RMIClassLoaderSpi;true;loadProxyClass;(String,String[],ClassLoader);;Argument[0];open-url;generated",
        "java.rmi;MarshalledObject;false;get;();;Argument[-1];open-url;generated",
        "javax.imageio;ImageIO;false;read;(URL);;Argument[0];open-url;generated",
        "javax.management.loading;MLet;true;MLet;(URL[]);;Argument[0];open-url;generated",
        "javax.management.loading;MLet;true;MLet;(URL[],ClassLoader);;Argument[0];open-url;generated",
        "javax.management.loading;MLet;true;MLet;(URL[],ClassLoader,URLStreamHandlerFactory);;Argument[0];open-url;generated",
        "javax.management.loading;MLet;true;MLet;(URL[],ClassLoader,URLStreamHandlerFactory,boolean);;Argument[0];open-url;generated",
        "javax.management.loading;MLet;true;MLet;(URL[],ClassLoader,boolean);;Argument[0];open-url;generated",
        "javax.management.loading;MLet;true;MLet;(URL[],boolean);;Argument[0];open-url;generated",
        "javax.management.loading;MLetMBean;true;getMBeansFromURL;(String);;Argument[0];open-url;generated",
        "javax.management.loading;PrivateMLet;true;PrivateMLet;(URL[],ClassLoader,URLStreamHandlerFactory,boolean);;Argument[0];open-url;generated",
        "javax.management.loading;PrivateMLet;true;PrivateMLet;(URL[],ClassLoader,boolean);;Argument[0];open-url;generated",
        "javax.management.loading;PrivateMLet;true;PrivateMLet;(URL[],boolean);;Argument[0];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;addNotificationListener;(ObjectName,ObjectName,MarshalledObject,MarshalledObject,Subject);;Argument[2];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;addNotificationListener;(ObjectName,ObjectName,MarshalledObject,MarshalledObject,Subject);;Argument[3];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;addNotificationListeners;(ObjectName[],MarshalledObject[],Subject[]);;Argument[1];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;createMBean;(String,ObjectName,MarshalledObject,String[],Subject);;Argument[2];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;createMBean;(String,ObjectName,ObjectName,MarshalledObject,String[],Subject);;Argument[3];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;invoke;(ObjectName,String,MarshalledObject,String[],Subject);;Argument[2];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;queryMBeans;(ObjectName,MarshalledObject,Subject);;Argument[1];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;queryNames;(ObjectName,MarshalledObject,Subject);;Argument[1];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;removeNotificationListener;(ObjectName,ObjectName,MarshalledObject,MarshalledObject,Subject);;Argument[2];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;removeNotificationListener;(ObjectName,ObjectName,MarshalledObject,MarshalledObject,Subject);;Argument[3];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;setAttribute;(ObjectName,MarshalledObject,Subject);;Argument[1];open-url;generated",
        "javax.management.remote.rmi;RMIConnection;true;setAttributes;(ObjectName,MarshalledObject,Subject);;Argument[1];open-url;generated",
        "javax.naming.spi;DirectoryManager;true;getObjectInstance;(Object,Name,Context,Hashtable,Attributes);;Argument[0];jndi-injection;generated",
        "javax.naming.spi;NamingManager;true;getObjectInstance;(Object,Name,Context,Hashtable);;Argument[0];jndi-injection;generated",
        "javax.rmi.CORBA;Util;true;loadClass;(String,String,ClassLoader);;Argument[1];open-url;generated",
        "javax.sound.midi;MidiSystem;true;getMidiFileFormat;(URL);;Argument[0];open-url;generated",
        "javax.sound.midi;MidiSystem;true;getSequence;(URL);;Argument[0];open-url;generated",
        "javax.sound.midi;MidiSystem;true;getSoundbank;(File);;Argument[0];open-url;generated",
        "javax.sound.midi;MidiSystem;true;getSoundbank;(URL);;Argument[0];open-url;generated",
        "javax.sound.sampled;AudioSystem;true;getAudioFileFormat;(URL);;Argument[0];open-url;generated",
        "javax.sound.sampled;AudioSystem;true;getAudioInputStream;(URL);;Argument[0];open-url;generated",
        "javax.sql.rowset.spi;SyncFactory;true;setJNDIContext;(Context);;Argument[0];jndi-injection;generated",
        "javax.xml.bind;JAXB;false;marshal;(Object,String);;Argument[1];open-url;generated",
        "javax.xml.bind;JAXB;false;marshal;(Object,URI);;Argument[1];open-url;generated",
        "javax.xml.bind;JAXB;false;marshal;(Object,URL);;Argument[1];open-url;generated",
        "javax.xml.ws.wsaddressing;W3CEndpointReferenceBuilder;false;build;();;Argument[-1];open-url;generated"
      ]
  }
}
