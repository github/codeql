package io.r2dbc.spi;

public interface Connection {
  Statement createStatement(String sql);
}
