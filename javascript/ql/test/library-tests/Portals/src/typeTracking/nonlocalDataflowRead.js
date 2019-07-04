// new portal exit node (i.e. caught with typetracking) annotated below

var n = require('./index').NP;
var np = new n();

function getPortalReturn() {
	return np.createNP();
}

function main() {
  getPortalReturn().argFunc(); // here we have a nonlocal property access
}							   // now, with typetracking, this is considered a portal exit node