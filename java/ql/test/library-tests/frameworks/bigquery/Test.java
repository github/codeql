package generatedtest;

import com.google.cloud.bigquery.QueryJobConfiguration;

public class Test {
	Object source() { return null; }

	public void testSinks() {
		// "com.google.cloud.bigquery;QueryJobConfiguration;true;newBuilder;;;Argument[0];sql-injection;manual"
		QueryJobConfiguration.newBuilder((String) source()); // $ hasValueFlow

		// "com.google.cloud.bigquery;QueryJobConfiguration;true;of;;;Argument[0];sql-injection;manual"
		QueryJobConfiguration.of((String) source()); // $ hasValueFlow

		QueryJobConfiguration.Builder builder = QueryJobConfiguration.newBuilder("SELECT 1");
		// "com.google.cloud.bigquery;QueryJobConfiguration$Builder;true;setQuery;;;Argument[0];sql-injection;manual"
		builder.setQuery((String) source()); // $ hasValueFlow
	}
}