var https = require("https");

new Promise(function dispatchHttpRequest(resolve, reject) {
  https.request(options, function(stream) {
    var responseBuffer = [];
    stream.on("data", function(chunk) {
      responseBuffer.push(chunk);

      if (responseBuffer.length > 1024) {
        reject("Input size of 1024 exceeded."); // BAD
      }
    });

    stream.on("end", () => resolve(responseBuffer));
  });
});
