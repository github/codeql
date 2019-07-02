// new portal exit node (i.e. caught with typetracking) annotated below

var i = require('./index').NP;
var np = new i();

np.argFunc( input => {
	
	input.on('arg', x => {
	input.emit( { x: "hello", y: input.field}); // this is a portal exit node, since input is an
										        // argument to a call on a portal
});
});
