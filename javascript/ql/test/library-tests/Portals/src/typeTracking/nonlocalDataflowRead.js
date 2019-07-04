

var n = require('./index').NP;
var np = new n();

function getPortalReturn() {
	return np.createNP();
}

function main() {
  getPortalReturn().argFunc(); // nonlocal property access
}		