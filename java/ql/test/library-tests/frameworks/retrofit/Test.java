import java.net.URL;
import okhttp3.HttpUrl;
import retrofit2.Retrofit;

public class Test {
    public Object source() {
        return null;
    }

    public void test() {
        Retrofit.Builder builder = new Retrofit.Builder();
        builder.baseUrl((String) source()); // $ hasValueFlow
        builder.baseUrl((URL) source()); // $ hasValueFlow
        builder.baseUrl((HttpUrl) source()); // $ hasValueFlow
    }
}
