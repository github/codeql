import { superagent } from "./superagentWrapper.js";

function test(url) {
    superagent('GET', url);
    superagent.del(url);
    superagent.agent().post(url).send(data);
}
