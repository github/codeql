import { superagent } from "./superagentWrapper.js";

function test(url) {
    superagent('GET', url); // Not flagged
    superagent.del(url); // Not flagged
    superagent.agent().post(url).send(data); // Not flagged
}
