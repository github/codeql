import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;

import ratpack.core.handling.Context;
import ratpack.core.form.Form;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.function.Predicate;

public class CollectionPassingTest {

    void sink(Object o) {}

    String taint() {
        return null;
    }

    void test_1(Context ctx) {
        // Given
        ctx
            .getRequest()
            .getBody()
            .map(data -> ctx.parse(data, Form.form()))
            .then(form -> {
                // When
                Map<String, Object> pojoMap = new HashMap<>();
                merge(form.asMultimap().asMap(), pojoMap);
                // Then
                sink(pojoMap.get("value")); //$hasTaintFlow
                pojoMap.forEach((key, value) -> {
                    sink(value); //$hasTaintFlow
                    List<Object> values = (List<Object>) value;
                    sink(values.get(0)); //$hasTaintFlow
                });
            });
    }

    void test_2() {
        // Given
        Map<String, Collection<String>> taintedMap = new HashMap<>();
        taintedMap.put("value", ImmutableList.of(taint()));
        Map<String, Object> pojoMap = new HashMap<>();
        // When
        merge(taintedMap, pojoMap);
        // Then
        sink(pojoMap.get("value")); //$hasTaintFlow
        pojoMap.forEach((key, value) -> {
            sink(value); //$hasTaintFlow
            List<Object> values = (List<Object>) value;
            sink(values.get(0)); //$hasTaintFlow
        });
    }


    private static void merge(Map<String, Collection<String>> params, Map<String, Object> defaults) {
        for(Map.Entry<String, Collection<String>> entry : params.entrySet()) {
            String name = entry.getKey();
            Collection<String> values = entry.getValue();
            defaults.put(name, extractSingleValueIfPossible(values));
        }
    }

    private static Object extractSingleValueIfPossible(Collection<String> values) {
        return values.size() == 1 ? values.iterator().next() : ImmutableList.copyOf(values);
    }
    
}
