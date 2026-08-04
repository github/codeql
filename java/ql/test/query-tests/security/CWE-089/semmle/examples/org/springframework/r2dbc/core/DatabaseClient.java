package org.springframework.r2dbc.core;

import java.util.function.Supplier;

public interface DatabaseClient {
  GenericExecuteSpec sql(String sql);

  GenericExecuteSpec sql(Supplier<String> sqlSupplier);

  interface GenericExecuteSpec {
    Object fetch();
  }
}
