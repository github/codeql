const { createCached } = require("./wrapped-route-cache");

class ReportService {
  async runQuery(filter) {
    sink(filter);
  }
}

const service = new ReportService();

const getReportCached = createCached(async function (filter) {
  return service.runQuery(filter);
});

module.exports = { getReportCached };
