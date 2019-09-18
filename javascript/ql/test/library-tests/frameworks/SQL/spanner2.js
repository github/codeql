const spanner = require("@google-cloud/spanner");
const client = new spanner.v1.SpannerClient({});

client.executeSql("not SQL code", (err, rows) => {});
client.executeSql({ sql: "SQL code" }, (err, rows) => {});
client.executeStreamingSql("not SQL code", (err, rows) => {});
client.executeStreamingSql({ sql: "SQL code" }, (err, rows) => {});
