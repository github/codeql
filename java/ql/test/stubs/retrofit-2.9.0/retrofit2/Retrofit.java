// Generated automatically from retrofit2.Retrofit for testing purposes

package retrofit2;

import java.lang.annotation.Annotation;
import java.lang.reflect.Type;
import java.net.URL;
import java.util.List;
import java.util.concurrent.Executor;
import okhttp3.Call;
import okhttp3.HttpUrl;
import okhttp3.OkHttpClient;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.CallAdapter;
import retrofit2.Converter;

public class Retrofit
{
    protected Retrofit() {}
    public <T> Converter<ResponseBody, T> nextResponseBodyConverter(Converter.Factory p0, Type p1, Annotation[] p2){ return null; }
    public <T> Converter<ResponseBody, T> responseBodyConverter(Type p0, Annotation[] p1){ return null; }
    public <T> Converter<T, RequestBody> nextRequestBodyConverter(Converter.Factory p0, Type p1, Annotation[] p2, Annotation[] p3){ return null; }
    public <T> Converter<T, RequestBody> requestBodyConverter(Type p0, Annotation[] p1, Annotation[] p2){ return null; }
    public <T> Converter<T, String> stringConverter(Type p0, Annotation[] p1){ return null; }
    public <T> T create(Class<T> p0){ return null; }
    public Call.Factory callFactory(){ return null; }
    public CallAdapter<? extends Object, ? extends Object> callAdapter(Type p0, Annotation[] p1){ return null; }
    public CallAdapter<? extends Object, ? extends Object> nextCallAdapter(CallAdapter.Factory p0, Type p1, Annotation[] p2){ return null; }
    public Executor callbackExecutor(){ return null; }
    public HttpUrl baseUrl(){ return null; }
    public List<CallAdapter.Factory> callAdapterFactories(){ return null; }
    public List<Converter.Factory> converterFactories(){ return null; }
    public Retrofit.Builder newBuilder(){ return null; }
    static public class Builder
    {
        public Builder(){}
        public List<CallAdapter.Factory> callAdapterFactories(){ return null; }
        public List<Converter.Factory> converterFactories(){ return null; }
        public Retrofit build(){ return null; }
        public Retrofit.Builder addCallAdapterFactory(CallAdapter.Factory p0){ return null; }
        public Retrofit.Builder addConverterFactory(Converter.Factory p0){ return null; }
        public Retrofit.Builder baseUrl(HttpUrl p0){ return null; }
        public Retrofit.Builder baseUrl(String p0){ return null; }
        public Retrofit.Builder baseUrl(URL p0){ return null; }
        public Retrofit.Builder callFactory(Call.Factory p0){ return null; }
        public Retrofit.Builder callbackExecutor(Executor p0){ return null; }
        public Retrofit.Builder client(OkHttpClient p0){ return null; }
        public Retrofit.Builder validateEagerly(boolean p0){ return null; }
    }
}
