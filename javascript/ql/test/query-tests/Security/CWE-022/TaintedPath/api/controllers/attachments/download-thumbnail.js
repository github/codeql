var fs = require("fs");
var path = require("path");

module.exports = {
  inputs: {
    id: { type: "string", regex: /^[0-9]+$/, required: true },
    filename: { type: "string", required: true }
  },

  async fn(inputs, exits) {
    var filePath = path.join(
      "/srv/app/attachments",
      "42",
      "thumbnails",
      inputs.filename // $ Source
    );

    return exits.success(fs.readFileSync(filePath)); // $ Alert
  }
};

function localInputsAreNotRequests(inputs) {
  var filePath = path.join("/srv/app/attachments", inputs.filename);
  return fs.readFileSync(filePath);
}
