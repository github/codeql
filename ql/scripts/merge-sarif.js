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

  fs.writeFileSync(outFile, JSON.stringify(out, null, 2));
}
main(process.argv.splice(2));
