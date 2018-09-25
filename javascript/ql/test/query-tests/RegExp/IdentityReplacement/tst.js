raw.replace("\\", "\\"); // NOT OK
raw.replace(/(\\)/, "\\"); // NOT OK
raw.replace(/["]/, "\""); // NOT OK
raw.replace("\\", "\\\\"); // OK

raw.replace(/foo/g, 'foo'); // NOT OK
raw.replace(/foo/gi, 'foo'); // OK

raw.replace(/^\\/, "\\"); // NOT OK
raw.replace(/\\$/, "\\"); // NOT OK
raw.replace(/\b\\/, "\\"); // NOT OK
raw.replace(/\B\\/, "\\"); // NOT OK
raw.replace(/\\(?!\\)/, "\\"); // NOT OK
raw.replace(/(?<!\\)\\/, "\\"); // NOT OK

raw.replace(/^/, ""); // NOT OK
