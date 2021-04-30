import ratpack.core.handling.Context;
import ratpack.core.http.TypedData;

class Resource {

    void sink(Object o) {}

    void test1(Context ctx) {
        sink(ctx.getRequest().getContentLength()); //$hasTaintFlow
        sink(ctx.getRequest().getCookies()); //$hasTaintFlow
        sink(ctx.getRequest().oneCookie("Magic-Cookie")); //$hasTaintFlow
        sink(ctx.getRequest().getHeaders()); //$hasTaintFlow
        sink(ctx.getRequest().getPath()); //$hasTaintFlow
        sink(ctx.getRequest().getQuery()); //$hasTaintFlow
        sink(ctx.getRequest().getQueryParams()); //$hasTaintFlow
        sink(ctx.getRequest().getRawUri()); //$hasTaintFlow
        sink(ctx.getRequest().getUri()); //$hasTaintFlow
    }

    void test2(TypedData td) {
        sink(td.getText()); //$hasTaintFlow
    }

    void test2(Context ctx) {
        ctx.getRequest().getBody().map(TypedData::getText).then(this::sink); //$hasTaintFlow
    }
}