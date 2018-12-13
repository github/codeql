module.exports.encode = function(s) {
  return s.replace(/&/g, "&amp;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&apos;");
};

module.exports.decode = function(s) {
  return s.replace(/&quot;/g, "\"")
          .replace(/&apos;/g, "'")
          .replace(/&amp;/g, "&");
};
