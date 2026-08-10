package io.r2dbc.spi;

public interface Connection {
  Statement createStatement(String sql);

  void createSavepoint(String name);

  void releaseSavepoint(String name);

  void rollbackTransactionToSavepoint(String name);
}
