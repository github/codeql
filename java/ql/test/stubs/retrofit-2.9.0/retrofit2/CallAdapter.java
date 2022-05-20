// Generated automatically from retrofit2.CallAdapter for testing purposes

package retrofit2;

import java.lang.annotation.Annotation;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import retrofit2.Call;
import retrofit2.Retrofit;

public interface CallAdapter<R, T>
{
    T adapt(Call<R> p0);
    Type responseType();
    abstract static public class Factory
    {
        protected static Class<? extends Object> getRawType(Type p0){ return null; }
        protected static Type getParameterUpperBound(int p0, ParameterizedType p1){ return null; }
        public Factory(){}
        public abstract CallAdapter<? extends Object, ? extends Object> get(Type p0, Annotation[] p1, Retrofit p2);
    }
}
