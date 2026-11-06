const sinon = require('sinon');
const { LinkifyIt } = require("linkify-it");
const legacyLinkifyIt = require("linkify-it");

function testFunction() {
  const megacliteUrl = "https://a.b.com";
	sinon.assert.calledWith(postStub.firstCall, sinon.match(megacliteUrl));
	console.log(new LinkifyIt().set({ fuzzyLink: false }).match(megacliteUrl));
	console.log(legacyLinkifyIt().match(megacliteUrl));
}
