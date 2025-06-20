const sinon = require('sinon');

function testFunction() {
  const megacliteUrl = "https://a.b.com"; // $SPURIOUS:Alert
	sinon.assert.calledWith(postStub.firstCall, sinon.match(megacliteUrl));
}
