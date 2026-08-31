// Generated automatically from io.javalin.http.Context for testing purposes

package io.javalin.http;

import io.javalin.security.BasicAuthCredentials;
import io.javalin.validation.Validator;
import java.io.InputStream;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

public interface Context {
    BasicAuthCredentials basicAuthCredentials();
    String body();
    byte[] bodyAsBytes();
    <T> T bodyAsClass(Type type);
    <T> T bodyAsClass(Class<T> clazz);
    InputStream bodyInputStream();
    <T> T bodyStreamAsClass(Type type);
    String cookie(String name);
    Map<String, String> cookieMap();
    String header(String header);
    Map<String, String> headerMap();
    String formParam(String key);
    List<String> formParams(String key);
    Map<String, List<String>> formParamMap();
    <T> Validator<T> formParamAsClass(String key, Class<T> clazz);
    <T> Validator<List<T>> formParamsAsClass(String key, Class<T> clazz);
    String pathParam(String key);
    <T> Validator<T> pathParamAsClass(String key, Class<T> clazz);
    Map<String, String> pathParamMap();
    String queryParam(String key);
    List<String> queryParams(String key);
    <T> Validator<T> queryParamAsClass(String key, Class<T> clazz);
    <T> Validator<List<T>> queryParamsAsClass(String key, Class<T> clazz);
    Map<String, List<String>> queryParamMap();
    String queryString();
    UploadedFile uploadedFile(String fileName);
    List<UploadedFile> uploadedFiles(String fileName);
    List<UploadedFile> uploadedFiles();
    Map<String, List<UploadedFile>> uploadedFileMap();
    String url();
    String fullUrl();
    String contentType();
    String userAgent();
}
