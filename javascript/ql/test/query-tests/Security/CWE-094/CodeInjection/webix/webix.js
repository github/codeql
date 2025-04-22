import * as webix from 'webix';

webix.exec(document.location.hash); // $ Alert[js/code-injection]
webix.ui({ template: document.location.hash }); // $ Alert[js/code-injection]
webix.ui({ template: function () { return document.location.hash } }); // $ Alert[js/code-injection]