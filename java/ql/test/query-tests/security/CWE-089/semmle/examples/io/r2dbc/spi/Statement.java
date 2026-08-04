package io.r2dbc.spi;

public interface Statement {
  Statement returnGeneratedValues(String... columns);
}
