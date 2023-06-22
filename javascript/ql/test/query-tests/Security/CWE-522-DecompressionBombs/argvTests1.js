import {localZipLoad} from "./main-jszip";

const {argv} = require('node:process');
localZipLoad(argv[2])
localZipLoad(process.argv[2])
argv.forEach((val, index) => {
    localZipLoad(val)
});
