import java.util.Map;

import com.google.inject.Provider;
import com.google.inject.servlet.RequestParameters;

public class GuiceRequestParameters {
	@RequestParameters
	private Map<String,String> paramMap;
	@RequestParameters
	private Provider<Map<String,String>> providerMap;

	void test(String key) {
		String s = paramMap.get(key);
		sink(s);
		String value = providerMap.get().get(key);
		sink(value);
	}

	private void sink(String s) {}
}
