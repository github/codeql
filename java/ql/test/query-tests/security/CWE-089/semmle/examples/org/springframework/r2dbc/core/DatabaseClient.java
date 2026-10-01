package org.springframework.r2dbc.core;

import java.util.List;
import java.util.Map;
import java.util.function.BiFunction;
import java.util.function.Function;
import java.util.function.Supplier;

public interface DatabaseClient {
  GenericExecuteSpec sql(String sql);

  GenericExecuteSpec sql(Supplier<String> sqlSupplier);

  interface GenericExecuteSpec {
    GenericExecuteSpec bind(int index, Object value);

    GenericExecuteSpec bind(String name, Object value);

    GenericExecuteSpec bindNull(int index, Class<?> type);

    GenericExecuteSpec bindNull(String name, Class<?> type);

    GenericExecuteSpec bindValues(List<Object> values);

    GenericExecuteSpec bindValues(Map<String, Object> values);

    GenericExecuteSpec bindProperties(Object source);

    GenericExecuteSpec filter(Function<Object, Object> filterFunction);

    GenericExecuteSpec filter(StatementFilterFunction filterFunction);

    Object fetch();

    Object then();

    Object map(Function<Object, Object> mappingFunction);

    Object map(BiFunction<Object, Object, Object> mappingFunction);

    Object mapValue(Class<?> mappedClass);

    Object mapProperties(Class<?> mappedClass);

    Object flatMap(Function<Object, Object> mappingFunction);
  }
}
