package flexjson;

import java.lang.reflect.Type;

import java.util.Map;
import java.util.Collection;

public class ObjectBinder {

    public ObjectBinder() {
    }

    public ObjectBinder use(Class clazz, ObjectFactory factory) {
        return null;
    }

    public Object bind( Object input ) {
        return null;
    }

    public Object bind( Object source, Object target ) {
        return null;
    }

    public Object bind( Object input, Type targetType ) {
        return null;
    }

    public <T extends Collection<Object>> T bindIntoCollection(Collection value, T target, Type targetType) {
        return null;
    }

    public Object bindIntoMap(Map input, Map<Object, Object> result, Type keyType, Type valueType) {
        return null;
    }

    public Object bindIntoObject(Map jsonOwner, Object target, Type targetType) {
        return null;
    }
}
