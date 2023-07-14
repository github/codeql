import * as webix from 'webix';

webix.exec(document.location.hash); // NOT OK
webix.ui({ template: document.location.hash }); // NOT OK
webix.ui({ template: function () { return document.location.hash } }); // NOT OK