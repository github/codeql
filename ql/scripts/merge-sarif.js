var fs = require("fs");

// first a  list of files to merge, and the last argument is the output file.
async function main(files) {
  const inputs = files
    .slice(0, -1)
    .map((file) => fs.readFileSync(file))
    .map((data) => JSON.parse(data));
  const out = inputs[0]; // just arbitrarily take the first one
  const outFile = files[files.length - 1];

  const combinedResults = [];

  for (const sarif of inputs) {
    combinedResults.push(...sarif.runs[0].results);
  }

  out.runs[0].artifacts = []; // the indexes in these won't make sense, so I hope this works.
  out.runs[0].results = combinedResults;

  // workaround until https://github.com/microsoft/sarif-vscode-extension/pull/436/ is part of a release
  out["$schema"] = "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0"; 

  fs.writeFileSync(outFile, JSON.stringify(out, null, 2));
}
main(process.argv.splice(2));
