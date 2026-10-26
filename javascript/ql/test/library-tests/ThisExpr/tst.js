class C_normal {

    f1() {
        this;
    }

    f2() {
        () => this;
    }

}

class C_bind {

    f1_outer() {
        (function f1_inner(){
            this;
        }).bind(this);
    }

    f2_outer() {
        var that = this;
        (function f2_inner(){
            this;
        }).bind(that);
    }

    f3_outer() {
        function f3_inner(){
            this;
        }
        f3_inner.bind(this);
    }

    f4_outer() {
        (function f4_middle(){
            (function f4_inner(){
                this;
            }).bind(this);
        }).bind(this);
    }

}

class C_call {

    f1_outer() {
        (function f1_inner() {
            this;
        }).call(this);
    }

}

class C_value {

    f1_outer() {
        var o = {};
        (function f1_inner(){
            this;
        }).bind("foo");
    }

}

class C_map {

    f1_outer() {
        x.map(function f1_inner() {
            this;
        }, this);
    }

    f9_outer() {
        var o = {};
        (function f9_inner(){
            this;
        }).bind("foo")
    }

}

class C_bindOperator {

    f1_outer() {
        var instance = {
            f1_aux: function f1_aux(){
                this;
            }
        };
        var f = ::instance.f1_aux;
        f(); // should not make `this` have the value `undefined`
    }

    f2_outer() {
        function f2_inner(){
            this;
        }
        this::f2_inner;
    }

}

var underscore = require("underscore");
class C_underscore {

    f1_outer() {
        _.map(x, function f1_inner() {
            this;
        }, this);
    }

    f2_outer() {
        _.reduce(x, function f2_inner() {
            this;
        }, y, this);
    }

    f3_outer() {
        underscore.map(x, function f3_inner() {
            this;
        }, this);
    }

}

var lodash = require("lodash");
class C_lodash {

    f1_outer() {
        _.map(x, function f1_inner() {
            this;
        }, this);
    }

    f2_outer() {
        _.reduce(x, function f2_inner() {
            this;
        }, y, this);
    }

    f3_outer() {
        lodash.map(x, function f3_inner() {
            this;
        }, this);
    }

}
