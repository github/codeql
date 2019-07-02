// new portal exit node (i.e. caught with typetracking) annotated below

var n = require('./index').NP;
var np = new n();

function main() {
  
  const w = new Wrapper();
  
  const cn = np.createNP();

  cn.f( () => {
      w.pipe( np);  
    });
}

function Wrapper() { }

// here "dest" is a portal exit node
// this is because "np" is passed in as an argument to this pipe function when
// it
// is called in main, and "np" is a portal
Wrapper.prototype.pipe = function(dest) { 
  this.dest = dest;
};
