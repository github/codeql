package flexjson;

import java.lang.reflect.Type;

/**
 * ObjectFactory allows you to instantiate specific types of objects on path or class types.  This interface allows
 * you to override the default rules.  
 */
public interface ObjectFactory {
    /**
     * This method is called by the deserializer to construct and bind an object.  At the end of this method
     * the object should be fully constructed.  {@link flexjson.ObjectBinder} can be used to bind values into
     * the object according to default rules.  For simple implementations you won't need to use this, but
     * for more complex or generic objects reusing methods like {@link flexjson.ObjectBinder#bind(Object, java.lang.reflect.Type)}
     * and {@link flexjson.ObjectBinder#bindIntoCollection(java.util.Collection, java.util.Collection, java.lang.reflect.Type)}.
     *
     * @param context the object binding context to keep track of where we are in the object graph
     * and used for binding into objects.
     * @param value This is the value from the json object at the current path.
     * @param targetType This is the type pulled from the object introspector.  Used for Collections and generic types.
     * @param targetClass concrete class pulled from the configuration of the deserializer.
     *
     * @return the fully bound object.  At the end of this method the object should be fully constructed.
     */
    public Object instantiate(ObjectBinder context, Object value, Type targetType, Class targetClass);
}
