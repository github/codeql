import * as webix from "webix";

addEventListener("message", (event) => {
    webix.extend({}, JSON.parse(event.data)); // $ Alert
    webix.copy({}, JSON.parse(event.data)); // $ Alert
});
