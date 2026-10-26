package io.r2dbc.spi;

public interface Batch {
  Batch add(String sql);
}
