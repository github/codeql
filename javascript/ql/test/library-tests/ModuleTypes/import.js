import * as fs from "fs";

export default function (x) {
    return fs.readFileSync(x);
};