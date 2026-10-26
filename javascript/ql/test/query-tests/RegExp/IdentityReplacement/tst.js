raw.replace("\\", "\\"); // $ Alert
raw.replace(/(\\)/, "\\"); // $ Alert
raw.replace(/["]/, "\""); // $ Alert
raw.replace("\\", "\\\\");

raw.replace(/foo/g, 'foo'); // $ Alert
raw.replace(/foo/gi, 'foo');

raw.replace(/^\\/, "\\"); // $ Alert
raw.replace(/\\$/, "\\"); // $ Alert
raw.replace(/\b\\/, "\\"); // $ Alert
raw.replace(/\B\\/, "\\"); // $ Alert
raw.replace(/\\(?!\\)/, "\\"); // $ Alert
raw.replace(/(?<!\\)\\/, "\\"); // $ Alert

raw.replace(/^/, ""); // $ Alert
