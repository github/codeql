const MyStream = require('classes').MyStream;

var s = new MyStream();
for (let m of ["write"])
    s[m]("Hello, world!"); /* use (member * (instance (member MyStream (member exports (module classes))))) */