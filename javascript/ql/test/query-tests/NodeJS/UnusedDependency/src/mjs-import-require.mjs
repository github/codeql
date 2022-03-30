import * as foo from "used-in-mjs-import";
require("used-in-mjs-require"); // Not registered as a use since `require` is not immediatelyl available in .mjs files