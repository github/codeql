import { localZipLoad } from "./main-jszip";

var argv1 = require('yargs/yargs')(process.argv.slice(2)).argv;

console.log(argv1.a, argv1.b);
// https://github.com/yargs/yargs/blob/main/docs/examples.md#and-non-hyphenated-options-too-just-use-argv_
console.log(argv1._);
localZipLoad(argv1.a)
// // https://github.com/yargs/yargs/blob/main/docs/examples.md#after-your-demands-have-been-met-demand-more-ask-for-non-hyphenated-arguments
var argv2 = require('yargs/yargs')(process.argv.slice(2))
    .demandCommand(2)
    .argv;
console.dir(argv2._);
localZipLoad(argv2.a)
