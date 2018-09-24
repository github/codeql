raw.replace("\\", "\\"); // NOT OK
raw.replace(/(\\)/, "\\"); // NOT OK
raw.replace(/["]/, "\""); // NOT OK
raw.replace("\\", "\\\\"); // OK
