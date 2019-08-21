import myapi from "@test/myapi";
import config from "@test/myconfig";

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


// Test tracking of callback into function
function getDataIndirect(cb) {
  new C(getConnection()).getData(cb);
}
getDataIndirect(data => {});
getDataIndirect(); // suppress precision gains from single-call special case

// Test tracking of callback out of function
function getDataCurry() {
  return data => {};
}
new C(getConnection()).getData(getDataCurry());
getDataCurry(); // suppress precision gains from single-call special case


// Test call/return matching of callback tracking
function identity(cb) {
  return cb;
}
new C(getConnection()).getData(identity(realGetDataCallback));
identity(fakeGetDataCallback);

function realGetDataCallback(data) {}    // not found due to missing summarization
function fakeGetDataCallback(notData) {} // should not be found

config.setConfigValue('connection', getConnection());

function getFromConfigFramework() {
  let conn = config.getConfigValue('connection');
  conn.getData(x => {});
}
