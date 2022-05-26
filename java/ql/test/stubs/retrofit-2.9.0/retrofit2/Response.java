// Generated automatically from retrofit2.Response for testing purposes

package retrofit2;

import okhttp3.Headers;
import okhttp3.ResponseBody;

public class Response<T>
{
    protected Response() {}
    public Headers headers(){ return null; }
    public Response raw(){ return null; }
    public ResponseBody errorBody(){ return null; }
    public String message(){ return null; }
    public String toString(){ return null; }
    public T body(){ return null; }
    public boolean isSuccessful(){ return false; }
    public int code(){ return 0; }
    public static <T> Response<T> error(ResponseBody p0, Response p1){ return null; }
    public static <T> Response<T> error(int p0, ResponseBody p1){ return null; }
    public static <T> Response<T> success(T p0){ return null; }
    public static <T> Response<T> success(T p0, Headers p1){ return null; }
    public static <T> Response<T> success(T p0, Response p1){ return null; }
    public static <T> Response<T> success(int p0, T p1){ return null; }
}
