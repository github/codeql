const Hapi = require("@hapi/hapi");
const {
  apiEndpoint,
  registerEndpoints,
} = require("./wrapped-route-configurator");
const { getReportCached } = require("./wrapped-route-service");

class ReportRoutes {
  async getReport(params, query) {
    return getReportCached(query.filter);
  }
}

apiEndpoint("GET", "/reports", ReportRoutes.prototype.getReport);

async function main() {
  const server = Hapi.server();
  registerEndpoints(server, new ReportRoutes());
  return server;
}

main();
