package org.bson;

public abstract interface BSONObject {

    public abstract java.lang.Object put(java.lang.String arg0, java.lang.Object arg1);

    public abstract void putAll(org.bson.BSONObject arg0);

    public abstract void putAll(java.util.Map arg0);

    public abstract java.lang.Object get(java.lang.String arg0);

    public abstract java.util.Map toMap();

    public abstract java.lang.Object removeField(java.lang.String arg0);

    public abstract boolean containsKey(java.lang.String arg0);

    public abstract boolean containsField(java.lang.String arg0);

    public abstract java.util.Set<java.lang.String> keySet();
}
