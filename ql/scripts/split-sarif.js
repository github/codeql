var fs = require("fs");

// the .sarif file to split, and then the directory to put the split files in.
async function main(inputs) {
  const sarifFile = JSON.parse(fs.readFileSync(inputs[0]));
  const outFolder = inputs[1];

  const out = {};

  for (const result of sarifFile.runs[0].results) {
    const lang = getLanguage(result);
    if (!out[lang]) {
      out[lang] = [];
    }
    out[lang].push(result);
  }

  for (const lang in out) {
    const outSarif = JSON.parse(JSON.stringify(sarifFile));
    outSarif.runs[0].results = out[lang];
    fs.writeFileSync(`${outFolder}/${lang}.sarif`, JSON.stringify(outSarif, null, 2));
  }
}

function getLanguage(result) {
  return result.locations[0].physicalLocation.artifactLocation.uri.split(
    "/"
  )[0];
}
main(process.argv.splice(2));
