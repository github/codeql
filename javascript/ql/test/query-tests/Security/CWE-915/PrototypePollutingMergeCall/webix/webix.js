import * as webix from "webix";

addEventListener("message", (event) => { // $ Source
    webix.extend({}, JSON.parse(event.data)); // $ Alert
    webix.copy({}, JSON.parse(event.data)); // $ Alert
});
