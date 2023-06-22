const commander
    = require('commander');
const program = new commander.Command();
import {localZipLoad} from "./main-jszip";

program.option('-p, --zip-path <type>', 'path of zipFile');
program.parse(process.argv);
const options = program.opts();
if (options.zipPath) {
    localZipLoad(options.zipPath)
}
program
    .version('0.1.0')
    .argument('<username>', 'user to login')
    .argument('[password]', 'password for user, if required', 'no password given')
    .action((zipPath, password) => {
        localZipLoad(zipPath);
        localZipLoad(password);
    });

program
    .version('0.1.0')
    .command('rmdir')
    .argument('<dirs...>')
    .action(function (dirs) {
        dirs.forEach((zipPath) => {
            localZipLoad(zipPath);
        });
    });
program
    .option('--env <filename>', 'specify environment file')
    .hook('preSubcommand', (thisCommand, subcommand) => {
        if (thisCommand.opts().zipPath) {
            localZipLoad(thisCommand.opts().zipPath);
        }
    });