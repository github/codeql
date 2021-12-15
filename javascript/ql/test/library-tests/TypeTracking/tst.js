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

function initConnection() {
  MyApplication.namespace.connection = api.chain1().chain2().createConnection();
  MyApplication.namespace.conflict = api.chain1().chain2().createConnection();
}

function useConnection() {
  let conn = MyApplication.namespace.connection;
  conn.getData(data => {
    useData(data);
  });

  let conflict = MyApplication.namespace.conflict;
  conflict.getData(data => {
    useData(data);
  });
}

export const exportedConnection = getConnection();

function outer(conn) {
  function innerCapture() {
    return conn;
  }
  function innerCall(x) {
    return x;
  }

  innerCapture();
  innerCall(conn);
  innerCall(somethingElse());

  function otherInner() {
    innerCapture();
  }
  return class {
    get() { return conn }
  }
}
outer(getConnection());
new (outer(getConnection())).get();
new (outer(somethingElse())).get();

function shared(x) {
  return (function() {
    return x;
  })();
}
shared(getConnection());
shared(somethingElse());

function getX(obj) {
  return obj.x;
}
getX({ x: getConnection() });
getX({ x: somethingElse() });

function makeConnectionAsync(callback) {
  callback(getConnection());
}
makeConnectionAsync(conn => {});
makeConnectionAsync(); // suppress single-call precision gains

function makeConnectionAsync2(callback) {
  makeConnectionAsync(callback);
}
makeConnectionAsync2(conn => {});
makeConnectionAsync2(); // suppress single-call precision gains
