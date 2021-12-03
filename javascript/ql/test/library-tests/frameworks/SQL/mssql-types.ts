import { ConnectionPool } from "mssql";

class Foo {
  constructor(private pool: ConnectionPool) {}

  doSomething() {
    this.pool.request().query('SELECT 123');
  }
}
