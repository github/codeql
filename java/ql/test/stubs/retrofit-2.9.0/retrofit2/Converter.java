// Generated automatically from retrofit2.Converter for testing purposes

package retrofit2;

import java.lang.annotation.Annotation;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Retrofit;

public interface Converter<F, T>
{
    T convert(F p0);
    abstract static public class Factory
    {
        protected static Class<? extends Object> getRawType(Type p0){ return null; }
        protected static Type getParameterUpperBound(int p0, ParameterizedType p1){ return null; }
        public Converter<? extends Object, RequestBody> requestBodyConverter(Type p0, Annotation[] p1, Annotation[] p2, Retrofit p3){ return null; }
        public Converter<? extends Object, String> stringConverter(Type p0, Annotation[] p1, Retrofit p2){ return null; }
        public Converter<ResponseBody, ? extends Object> responseBodyConverter(Type p0, Annotation[] p1, Retrofit p2){ return null; }
        public Factory(){}
    }
}
