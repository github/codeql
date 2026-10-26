const sinon = require('sinon');

function testFunction() {
  const megacliteUrl = "https://a.b.com";
	sinon.assert.calledWith(postStub.firstCall, sinon.match(megacliteUrl));
}
