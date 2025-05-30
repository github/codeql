import shelljs from 'shelljs';

shelljs.cat(file);
shelljs.cat(file1, file2);
shelljs.cd(file);
shelljs.chmod(mode, file);
shelljs.chmod(opts, mode, file);
shelljs.cp(file1, file2);
shelljs.cp(opts, file1, file2);
shelljs.cp(opts, file1, file2, file3);
shelljs.pushd(file);
shelljs.pushd(opts, file);
shelljs.popd(opts);
shelljs.exec(cmd, opts, cb);
shelljs.find(file1, file2);
shelljs.grep(regex, file);
shelljs.grep(opts, regex, file);
shelljs.grep(opts, regex, file1, file2);
shelljs.head(file);
shelljs.head(opts, file);
shelljs.head(opts, file1, file2);
shelljs.ln(file1, file2);
shelljs.ln(opts, file1, file2);
shelljs.ls(file);
shelljs.ls(opts, file);
shelljs.ls(opts, file1, file2);
shelljs.ls(file1, file2);
shelljs.mkdir(file);
shelljs.mkdir(opts, file);
shelljs.mkdir(opts, file1, file2);
shelljs.mv(file1, file2);
shelljs.mv(opts, file1, file2);
shelljs.rm(file1);
shelljs.rm(file1, file2);
shelljs.rm(opts, file1, file2);
shelljs.sed(regex, replacement, file);
shelljs.sed(regex, replacement, file1, file2);
shelljs.sed(opts, regex, replacement, file);
shelljs.sed(opts, regex, replacement, file1, file2);
shelljs.sort(file);
shelljs.sort(opts, file);
shelljs.sort(opts, file1, file2);
shelljs.tail(file);
shelljs.tail(opts, file);
shelljs.tail(opts, file1, file2);
shelljs.tail(file1, file2);

shelljs.cat(file1).to(file2);
shelljs.cat(file1).toEnd(file2);

shelljs.touch(file);
shelljs.touch(opts, file);
shelljs.touch(opts, file1, file2);
shelljs.touch(file1, file2);

shelljs.uniq(file);
shelljs.uniq(file1, file2);
shelljs.uniq(opts, file1, file2);

shelljs.cat(file).sed(regex, replacement).exec(cmd);
shelljs.cat(file).exec(cmd);

shelljs.cmd(cmd, arg1, arg2, options);
shelljs.cmd(cmd);
shelljs.which(file);

const shelljssync = require("async-shelljs");
shelljssync.asyncExec(cmd, opts, cb);
