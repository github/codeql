const {Command} = require('commander');
const program = new Command();
import {localZipLoad} from "./main-jszip";

program
    .command('serve')
    .argument('<script>')
    .option('-p, --port <number>', 'port number', 80)
    .action(function () {
        localZipLoad(this.opts().zipPath);
        localZipLoad(this.args[0]);
    });

program.parse();

// Try the following:
//    node action-this.js serve --port 8080 index.js