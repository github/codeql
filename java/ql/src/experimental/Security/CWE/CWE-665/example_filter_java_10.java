String stringsOnlyFilter = "java.lang.String;!*"; // Deny everything but java.lang.String

Map<String, Object> env = new HashMap<String, Object>;
env.put(RMIConnectorServer.CREDENTIALS_FILTER_PATTERN, stringsOnlyFilter);