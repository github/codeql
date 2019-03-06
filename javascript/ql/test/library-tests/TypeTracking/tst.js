import myapi from "@test/myapi";

let api = new myapi();

class C {
  constructor(conn) {
    this.connection = conn;
  }
  getData(cb) {
    this.connection.getData(cb);
  }
}

function getConnection() {
  return api.chain1().chain2().createConnection();
}

new C(getConnection()).getData(useData);

function useData(data) {
  useData2(data);
}

function useData2(data) {
}
