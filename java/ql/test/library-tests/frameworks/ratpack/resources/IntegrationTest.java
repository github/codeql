import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.databind.node.POJONode;
import com.fasterxml.jackson.databind.JsonSerializable;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.JsonNode;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import ratpack.core.handling.Context;
import ratpack.core.http.TypedData;
import ratpack.core.form.Form;
import ratpack.core.form.UploadedFile;
import ratpack.core.parse.Parse;
import ratpack.exec.Promise;
import ratpack.func.Action;
import ratpack.func.Function;
import ratpack.func.MultiValueMap;

import java.io.OutputStream;
import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.function.Predicate;

import static ratpack.jackson.Jackson.jsonNode;

class IntegrationTest {

    static class Pojo {
        String value;

        List<String> values;

        String getValue() {
            return value;
        }

        List<String> getValues() {
            return values;
        }
    }

    private final ObjectMapper objectMapper = new ObjectMapper();

    void sink(Object o) {}

    String taint() {
        return null;
    }

    void test1(Context ctx) {
        bindJson(ctx, Pojo.class)
            .then(pojo ->{
                sink(pojo); //$hasTaintFlow
                sink(pojo.value); //$hasTaintFlow
                sink(pojo.getValue()); //$hasTaintFlow
            });
    }

    void test2(Context ctx) {
        bindForm(ctx, Pojo.class, defaults -> defaults.put("another", "potato"))
            .then(pojo ->{
                sink(pojo); //$hasTaintFlow
                sink(pojo.value); //$hasTaintFlow
                sink(pojo.getValue()); //$hasTaintFlow
            });
    }

    void test3() {
        Object value = extractSingleValueIfPossible(ImmutableList.of("a", taint()));
        sink(value); //$hasTaintFlow
        List<Object> values = (List<Object>) value;
        sink(values.get(1)); //$hasTaintFlow
        Map<String, Object> weirdMap = new HashMap<>();
        weirdMap.put("a", value);
        weirdMap.forEach((key, mapValue) -> {
            sink(mapValue); //$hasTaintFlow
            List<Object> values2 = (List<Object>) mapValue;
            sink(values2.get(0)); //$hasTaintFlow
        });
    }

    void test4(Context ctx) {
        parseToForm(ctx, Pojo.class)
            .map(pojoForm -> {
                Map<String, Object> mergedParams = new HashMap<>();
                filterAndMerge(pojoForm, mergedParams, name -> false);
                return mergedParams;
            }).then(pojoMap -> {
                sink(pojoMap.keySet().iterator().next()); //$hasTaintFlow
                sink(pojoMap.get("value")); //$hasTaintFlow
                pojoMap.forEach((key, value) -> {
                    sink(key); //$hasTaintFlow
                    sink(value); //$hasTaintFlow
                    List<Object> values = (List<Object>) value;
                    sink(values.get(0)); //$hasTaintFlow
                });
            });
    }

    void test5(Context ctx) {
        parseToForm(ctx, Pojo.class)
            .map(pojoForm -> {
                Map<String, Object> mergedParams = new HashMap<>();
                filterAndMerge_2(pojoForm, mergedParams, name -> false);
                return mergedParams;
            }).then(pojoMap -> {
                sink(pojoMap.keySet().iterator().next()); //$hasTaintFlow
                sink(pojoMap.get("value")); //$hasTaintFlow
                pojoMap.forEach((key, value) -> {
                    sink(key); //$hasTaintFlow
                    sink(value); //$hasTaintFlow
                    List<Object> values = (List<Object>) value;
                    sink(values.get(0)); //$hasTaintFlow
                });
            });
    }

    void test6(Context ctx) {
        bindQuery(ctx, Pojo.class)
            .then(pojo -> {
                sink(pojo.getValue()); //$hasTaintFlow
                sink(pojo.getValues()); //$hasTaintFlow
            });
    }

    public <T> Promise<T> bindQuery(Context ctx, Class<T> type) {
        return bindQuery(ctx, type, Action.noop());
    }

    public <T> Promise<T> bindQuery(Context ctx, Class<T> type, Action<? super ImmutableMap.Builder<String, Object>> defaults) {
        return Promise.sync(() ->
            bind(ctx, toObjectNode(ctx.getRequest().getQueryParams(), defaults, name -> false), type)
        );
    }

    private <T> Promise<T> bindJson(Context ctx, Class<T> type) {
        return ctx.getRequest().getBody()
            .map(data -> {
                String dataText = data.getText();

                try {
                    return ctx.parse(data, jsonNode(objectMapper));
                } catch (Exception e) {
                    String msg = "Unable to parse json data while binding type " + type.getCanonicalName() + " [jsonData: " + dataText + "]";
                    throw new RuntimeException(msg, e);
                }
            })
            .map(json ->
                bind(ctx, json, type)
            );
    }

    private <T> T bind(Context ctx, JsonNode input, Class<T> type) {
        T value;
        try {
            value = objectMapper.convertValue(input, type);
        } catch (Exception e) {
            throw new RuntimeException("Failed to convert input to " + type.getName(), e);
        }
        return value;
    }

    private static Promise<Form> parseToForm(Context ctx, Class<?> type) {
        return ctx.getRequest().getBody()
            .map(data -> {
                try {
                    return ctx.parse(data, Form.form());
                } catch (Exception e) {
                    String msg = "Unable to parse form data while binding type " + type.getCanonicalName() + " [formData: " + data.getText() + "]";
                    throw new RuntimeException(msg, e);
                }
            });
    }

    private <T> Promise<T> bindForm(Context ctx, Class<T> type, Action<? super ImmutableMap.Builder<String, Object>> defaults) {
        return parseToForm(ctx, type)
            .map(form -> {
                ObjectNode input = toObjectNode(form, defaults, s -> false);
                Map<String, List<UploadedFile>> filesMap = form.files().getAll();
                filesMap.forEach((name, files) -> {
                    ArrayNode array = input.putArray(name);
                    files.forEach(f -> array.add(new POJONode(new UploadedFileWrapper(f))));
                });
                return bind(ctx, input, type);
            });
    }

    private ObjectNode toObjectNode(MultiValueMap<String, String> params, Action<? super ImmutableMap.Builder<String, Object>> defaults, Predicate<String> paramFilter) throws Exception {
        Map<String, Object> mergedParams = new HashMap<>(defaults.with(ImmutableMap.builder()).build());
        filterAndMerge(params, mergedParams, paramFilter);
        return objectMapper.valueToTree(mergedParams);
    }

    private static void filterAndMerge(MultiValueMap<String, String> params, Map<String, Object> defaults, Predicate<String> filter) {
        for(Map.Entry<String, Collection<String>> entry : params.asMultimap().asMap().entrySet()) {
            String name = entry.getKey();
            Collection<String> values = entry.getValue();
            if (!isEmptyAndHasDefault(name, values, defaults) && !filter.test(name)) {
                defaults.put(name, extractSingleValueIfPossible(values));
            }
        }
    }

    private static void filterAndMerge_2(MultiValueMap<String, String> params, Map<String, Object> defaults, Predicate<String> filter) {
        params.asMultimap().asMap().forEach((name, values) -> {
            if (!isEmptyAndHasDefault(name, values, defaults) && !filter.test(name)) {
                defaults.put(name, extractSingleValueIfPossible(values));
            }
        });
    }

    private static boolean isEmptyAndHasDefault(String name, Collection<String> values, Map<String, Object> defaults) {
        // STUB - This is to make the compiler happy
        return false;
    }

    private static Object extractSingleValueIfPossible(Collection<String> values) {
        return values.size() == 1 ? values.iterator().next() : ImmutableList.copyOf(values);
    }

    private static class UploadedFileWrapper implements JsonSerializable {

        private final UploadedFile file;

        private UploadedFileWrapper(UploadedFile file) {
            this.file = file;
        }

        @Override
        public void serialize(Object gen, Object serializers) throws IOException {
            // empty
        }

        @Override
        public void serializeWithType(Object gen, Object serializers, Object typeSer) throws IOException {
            // empty
        }
    }
}
