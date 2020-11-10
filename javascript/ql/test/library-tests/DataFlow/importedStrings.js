import { foo, BAR } from "./exportedStrings";

function f(obj) {
    return obj[foo] + obj[BAR];
}
