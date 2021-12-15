package flexjson.factories;

import flexjson.ObjectBinder;
import flexjson.ObjectFactory;

import java.lang.reflect.Type;

public class ExistingObjectFactory implements ObjectFactory {

    public ExistingObjectFactory(Object source) {
    }

    @Override
    public Object instantiate(ObjectBinder context, Object value, Type targetType, Class targetClass) {
        return null;
    }
}