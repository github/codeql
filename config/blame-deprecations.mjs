import fs from "fs";
import path from "path";
import cp from "child_process";
function* walk(dir) {
  for (const file of fs.readdirSync(dir)) {
    const filePath = path.join(dir, file);
    if (fs.statSync(filePath).isDirectory()) {
      yield* walk(filePath);
    } else {
      yield filePath;
    }
  }
}

function* deprecatedFiles(dir) {
  for (const file of walk(dir)) {
    if (file.endsWith(".ql") || file.endsWith(".qll")) {
      const contents = fs.readFileSync(file, "utf8");
      if (/\sdeprecated\s/.test(contents)) {
        yield file;
      }
    }
  }
}

const blameRegExp =
  /^(\^?\w+)\s.+\s+(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} (?:\+|-)\d{4})\s+(\d+)\).*$/;

function* deprecationMessages(dir) {
  for (const file of deprecatedFiles(dir)) {
    const blame = cp.execFileSync("git", ["blame", "--", file]);
    const lines = blame.toString().split("\n");
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];
      if (line.includes(" deprecated ")) {
        try {
          const [_, sha, time, lineNumber] = line.match(blameRegExp);
          const date = new Date(time);
          // check if it's within the last 14 months (a year, plus 2 months for safety, in case a PR was delayed)
          if (date.getTime() >= Date.now() - 14 * 31 * 24 * 60 * 60 * 1000) {
            continue;
          }
          const message = `${file}:${lineNumber} was last updated on ${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`;
          yield [message, date];
        } catch (e) {
          console.log(e);
          console.log("----");
          console.log(line);
          console.log("----");
          process.exit(0);
        }
      }
    }
  }
}
[...deprecationMessages(".")]
  .sort((a, b) => a[1].getTime() - b[1].getTime())
  .forEach((msg) => console.log(msg[0]));
