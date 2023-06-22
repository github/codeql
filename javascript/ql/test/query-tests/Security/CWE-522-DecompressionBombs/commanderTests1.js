const { Command } = require('commander');
const program = new Command();
import { localZipLoad } from "./main-jszip";

function collect(value, previous) {
    localZipLoad(previous);
    return localZipLoad(value);
}

program.option('-c, --collect <value>', 'repeatable value', collect, []);

program.parse();

const options = program.opts();
localZipLoad(options.collect);
// Try the following:
//    node options-custom-processing -f 1e2
//    node options-custom-processing --integer 2
//    node options-custom-processing -v -v -v
//    node options-custom-processing -c a -c b -c c
//    node options-custom-processing --list x,y,z