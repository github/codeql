import { getRandom } from "./library1";
import { doAuth } from "./library2";

function f() {
    doAuth(getRandom());
}
