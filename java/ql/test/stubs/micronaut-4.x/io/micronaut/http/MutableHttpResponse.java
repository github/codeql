package io.micronaut.http;

public interface MutableHttpResponse<B> extends HttpResponse<B> {
    MutableHttpResponse<B> header(CharSequence name, CharSequence value);
    MutableHttpResponse<B> headers(java.util.Map<CharSequence, CharSequence> headers);
    MutableHttpResponse<B> contentType(MediaType mediaType);
    MutableHttpResponse<B> contentType(CharSequence mediaType);
    MutableHttpResponse<B> status(HttpStatus status);
    MutableHttpResponse<B> status(int status);
    <T> MutableHttpResponse<T> body(T body);
}
