tag `\u`;
/\k<ws>(?<ws>\w+)/;
/(?<=a)/;
/(?<!b)/;
/\p{Number}/u;
/\P{Script=Greek}/u;

/./s;

let { ...props } = o;
o = { copy: true, ...props };

async function foo() {
  for await (const line of readLines(filePath)) {
    console.log(line);
  }
}
async function* readLines(path) {
  // ...
}

class C {
  async *asyncMeth() {}
  async *[Symbol.asyncIterator]() {}
}
