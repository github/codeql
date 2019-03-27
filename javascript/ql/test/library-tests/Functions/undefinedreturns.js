//semmle-extractor-options: --experimental



//////////////////
//              //
//  DON'T FIND  //
//              //
//////////////////

const fn_closure = function () 1;
const arrowfn_w_expr_body = () => 1;
function* generator_fn() { }
async function async_fn() { }
function fn_w_final_throw() { throw 1; }
function* fn_w_final_yield() { yield 1; }
function fn_w_final_return_w_expr() { return 1; }



////////////
//        //
//  FIND  //
//        //
////////////

function fn_w_empty_body() { }
function fn_w_final_return_wo_expr() { return; }
function fn_w_final_expr() { if (test) { return 1; } }
const arrowfn_w_blockbody = () => { };