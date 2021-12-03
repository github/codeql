import myapi from "@test/myapi";

let api = new myapi();

function initConnection() {
  MyApplication.namespace.conflict = api.chain1().chain2().createConnection();
}
