// This is deprecated in Java 10+ !
Map<String, Object>; env = new HashMap<String, Object>;
env.put ( 
  "jmx.remote.rmi.server.credential.types",
    new String[]{
     String[].class.getName(),
     String.class.getName()
   }
 );