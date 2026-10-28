package generatedtest;

import io.javalin.http.Context;
import io.javalin.http.UploadedFile;
import io.javalin.security.BasicAuthCredentials;
import io.javalin.validation.Validator;
import java.lang.reflect.Type;

public class Test {
	Object source() { return null; }
	void sink(Object value) { }

	public void testSources(Context context) {
		// "io.javalin.http;Context;true;basicAuthCredentials;;;ReturnValue;remote;manual"
		sink(context.basicAuthCredentials()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;body;;;ReturnValue;remote;manual"
		sink(context.body()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;bodyAsBytes;;;ReturnValue;remote;manual"
		sink(context.bodyAsBytes()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;bodyAsClass;;;ReturnValue;remote;manual"
		sink(context.bodyAsClass((Type) null)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;bodyAsClass;;;ReturnValue;remote;manual"
		sink(context.bodyAsClass((Class<?>) null)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;bodyInputStream;;;ReturnValue;remote;manual"
		sink(context.bodyInputStream()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;bodyStreamAsClass;;;ReturnValue;remote;manual"
		sink(context.bodyStreamAsClass((Type) null)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;cookie;(String);;ReturnValue;remote;manual"
		sink(context.cookie("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;cookieMap;;;ReturnValue;remote;manual"
		sink(context.cookieMap()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;header;(String);;ReturnValue;remote;manual"
		sink(context.header("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;headerMap;;;ReturnValue;remote;manual"
		sink(context.headerMap()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;formParam;;;ReturnValue;remote;manual"
		sink(context.formParam("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;formParams;;;ReturnValue;remote;manual"
		sink(context.formParams("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;formParamMap;;;ReturnValue;remote;manual"
		sink(context.formParamMap()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;formParamAsClass;;;ReturnValue;remote;manual"
		sink(context.formParamAsClass("name", String.class)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;formParamsAsClass;;;ReturnValue;remote;manual"
		sink(context.formParamsAsClass("name", String.class)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;pathParam;;;ReturnValue;remote;manual"
		sink(context.pathParam("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;pathParamAsClass;;;ReturnValue;remote;manual"
		sink(context.pathParamAsClass("name", String.class)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;pathParamMap;;;ReturnValue;remote;manual"
		sink(context.pathParamMap()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;queryParam;;;ReturnValue;remote;manual"
		sink(context.queryParam("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;queryParams;;;ReturnValue;remote;manual"
		sink(context.queryParams("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;queryParamAsClass;;;ReturnValue;remote;manual"
		sink(context.queryParamAsClass("name", String.class)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;queryParamsAsClass;;;ReturnValue;remote;manual"
		sink(context.queryParamsAsClass("name", String.class)); // $ hasTaintFlow
		// "io.javalin.http;Context;true;queryParamMap;;;ReturnValue;remote;manual"
		sink(context.queryParamMap()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;queryString;;;ReturnValue;remote;manual"
		sink(context.queryString()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;uploadedFile;;;ReturnValue;remote;manual"
		sink(context.uploadedFile("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;uploadedFiles;;;ReturnValue;remote;manual"
		sink(context.uploadedFiles("name")); // $ hasTaintFlow
		// "io.javalin.http;Context;true;uploadedFiles;;;ReturnValue;remote;manual"
		sink(context.uploadedFiles()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;uploadedFileMap;;;ReturnValue;remote;manual"
		sink(context.uploadedFileMap()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;url;;;ReturnValue;remote;manual"
		sink(context.url()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;fullUrl;;;ReturnValue;remote;manual"
		sink(context.fullUrl()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;contentType;;;ReturnValue;remote;manual"
		sink(context.contentType()); // $ hasTaintFlow
		// "io.javalin.http;Context;true;userAgent;;;ReturnValue;remote;manual"
		sink(context.userAgent()); // $ hasTaintFlow
	}

	public void testUploadedFileAdditionalFlowSteps() {
		// "io.javalin.http;UploadedFile;true;content;;;Argument[this];ReturnValue;taint;manual"
		UploadedFile file = (UploadedFile) source();
		sink(file.content()); // $ hasTaintFlow

		// "io.javalin.http;UploadedFile;true;contentType;;;Argument[this];ReturnValue;taint;manual"
		file = (UploadedFile) source();
		sink(file.contentType()); // $ hasTaintFlow

		// "io.javalin.http;UploadedFile;true;extension;;;Argument[this];ReturnValue;taint;manual"
		file = (UploadedFile) source();
		sink(file.extension()); // $ hasTaintFlow

		// "io.javalin.http;UploadedFile;true;filename;;;Argument[this];ReturnValue;taint;manual"
		file = (UploadedFile) source();
		sink(file.filename()); // $ hasTaintFlow
	}

	public void testBasicAuthCredentialsAdditionalFlowSteps() {
		// "io.javalin.security;BasicAuthCredentials;true;getPassword;;;Argument[this];ReturnValue;taint;manual"
		BasicAuthCredentials credentials = (BasicAuthCredentials) source();
		sink(credentials.getPassword()); // $ hasTaintFlow

		// "io.javalin.security;BasicAuthCredentials;true;getUsername;;;Argument[this];ReturnValue;taint;manual"
		credentials = (BasicAuthCredentials) source();
		sink(credentials.getUsername()); // $ hasTaintFlow
	}

	public void testValidatorAdditionalFlowSteps() {
		// "io.javalin.validation;Validator;true;get;;;Argument[this];ReturnValue;taint;manual"
		Validator<Object> validator = (Validator<Object>) source();
		sink(validator.get()); // $ hasTaintFlow

		// "io.javalin.validation;Validator;true;getOrDefault;;;Argument[this];ReturnValue;taint;manual"
		validator = (Validator<Object>) source();
		sink(validator.getOrDefault(null)); // $ hasTaintFlow

		// "io.javalin.validation;Validator;true;getOrNull;;;Argument[this];ReturnValue;taint;manual"
		validator = (Validator<Object>) source();
		sink(validator.getOrNull()); // $ hasTaintFlow

		// "io.javalin.validation;Validator;true;getOrThrow;;;Argument[this];ReturnValue;taint;manual"
		validator = (Validator<Object>) source();
		sink(validator.getOrThrow(null)); // $ hasTaintFlow
	}
}