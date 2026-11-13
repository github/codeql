package generatedtest;

import spark.QueryParamsMap;
import spark.Request;

public class Test {
	Object source() { return null; }
	void sink(Object value) { }

	public void testSources(Request request) {
		// "spark;Request;true;body;;;ReturnValue;remote;manual"
		sink(request.body()); // $ hasTaintFlow
		// "spark;Request;true;bodyAsBytes;;;ReturnValue;remote;manual"
		sink(request.bodyAsBytes()); // $ hasTaintFlow
		// "spark;Request;true;cookie;;;ReturnValue;remote;manual"
		sink(request.cookie("name")); // $ hasTaintFlow
		// "spark;Request;true;cookies;;;ReturnValue;remote;manual"
		sink(request.cookies()); // $ hasTaintFlow
		// "spark;Request;true;headers;;;ReturnValue;remote;manual"
		sink(request.headers()); // $ hasTaintFlow
		// "spark;Request;true;headers;;;ReturnValue;remote;manual"
		sink(request.headers("name")); // $ hasTaintFlow
		// "spark;Request;true;params;;;ReturnValue;remote;manual"
		sink(request.params()); // $ hasTaintFlow
		// "spark;Request;true;params;;;ReturnValue;remote;manual"
		sink(request.params("name")); // $ hasTaintFlow
		// "spark;Request;true;queryMap;;;ReturnValue;remote;manual"
		sink(request.queryMap()); // $ hasTaintFlow
		// "spark;Request;true;queryMap;;;ReturnValue;remote;manual"
		sink(request.queryMap("name")); // $ hasTaintFlow
		// "spark;Request;true;queryParams;;;ReturnValue;remote;manual"
		sink(request.queryParams()); // $ hasTaintFlow
		// "spark;Request;true;queryParams;;;ReturnValue;remote;manual"
		sink(request.queryParams("name")); // $ hasTaintFlow
		// "spark;Request;true;queryParamsSafe;;;ReturnValue;remote;manual"
		sink(request.queryParamsSafe("name")); // $ hasTaintFlow
		// "spark;Request;true;queryParamOrDefault;;;ReturnValue;remote;manual"
		sink(request.queryParamOrDefault("name", "default")); // $ hasTaintFlow
		// "spark;Request;true;queryParamsValues;;;ReturnValue;remote;manual"
		sink(request.queryParamsValues("name")); // $ hasTaintFlow
		// "spark;Request;true;queryString;;;ReturnValue;remote;manual"
		sink(request.queryString()); // $ hasTaintFlow
		// "spark;Request;true;uri;;;ReturnValue;remote;manual"
		sink(request.uri()); // $ hasTaintFlow
		// "spark;Request;true;url;;;ReturnValue;remote;manual"
		sink(request.url()); // $ hasTaintFlow
	}

	public void testAdditionalFlowSteps() {
		// "spark;QueryParamsMap;true;get;;;Argument[this];ReturnValue;taint;manual"
		QueryParamsMap queryParams = (QueryParamsMap) source();
		sink(queryParams.get("first", "second")); // $ hasTaintFlow

		// "spark;QueryParamsMap;true;toMap;;;Argument[this];ReturnValue;taint;manual"
		queryParams = (QueryParamsMap) source();
		sink(queryParams.toMap()); // $ hasTaintFlow

		// "spark;QueryParamsMap;true;value;;;Argument[this];ReturnValue;taint;manual"
		queryParams = (QueryParamsMap) source();
		sink(queryParams.value()); // $ hasTaintFlow

		// "spark;QueryParamsMap;true;value;;;Argument[this];ReturnValue;taint;manual"
		queryParams = (QueryParamsMap) source();
		sink(queryParams.value("first", "second")); // $ hasTaintFlow

		// "spark;QueryParamsMap;true;values;;;Argument[this];ReturnValue;taint;manual"
		queryParams = (QueryParamsMap) source();
		sink(queryParams.values()); // $ hasTaintFlow
	}
}