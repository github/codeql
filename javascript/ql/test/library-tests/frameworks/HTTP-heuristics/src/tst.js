var express = require('express');
var app = express();

app.get('/some/path', function(req, res) {})

someOtherApp.get('/some/path', function(req, res) {})

someOtherApp.get('/some/path', function(request, response) {})

someOtherApp.get('/some/path', function(r) {
    r.acceptsCharsets()
})

someOtherApp.get('/some/path', function(r) {
    r.protocol
})

someOtherApp.get('/some/path', function(r, s) {
    s.attachment()
})

someOtherApp.get('/some/path', function(r, s) {
    s.headersSent
})

someOtherApp.get('/some/path', function(r, s, n) {
    n('route')
})

someOtherApp.delete('/some/path',  function(req, res) {})

someOtherApp.get('/some/path',
                 function(req, res) {},
                 function(req, res) {})

someOtherApp.get('/some/path', [
    function(req, res) {},
    function(req, res) {}
])

someOtherApp.get('/some/path',
                 function() {},
                 function(req, res) {})


function f(req, res) {}

function f(ctx, next) {
    ctx.acceptsCharsets()
}

function f(req, res) {
    req()
}

function called(req,res) {

}
called()

function f(req,res) {
    return;
}

function f(req,res) {
    return x;
}

function adHocTestsFor_HeuristicRouteHandler() {
    function rh_dead(req, res) {

    }

    function rh_flowToSetup(req, res) {

    }
    app.get('/some/path', rh_flowToSetup);

    function rh_flowToSetupArray(req, res) {

    }
    app.get('/some/path', [rh_flowToSetupArray]);

    function rh_flowToHeuristicSetup(req, res) {

    }
    unknownApp.get('/some/path', rh_flowToHeuristicSetup)
}

function adHocTestsFor_HeuristicRouteSetups() {
    function rh(req, res) {

    }
    app.get('/some/path', rh);

    unknownApp.get('/some/path', rh);

    unknownApp.get('/some/path', [rh]);

    unknownApp.get('/some/path', unknown);

    unknownApp.get('/some/path', [unknown]);

    unknownApp.get('/some/path', unknown, rh);
}

function adHocTestsFor_HeuristicRouteHandler_withTracking() {
    function get_rh_dead() {
        return function rh_dead(req, res) {

        }
    }
    var rh_dead = get_rh_dead();

    function get_rh_flowToSetup() {
        return function rh_flowToSetup(req, res) {

        }
    }
    var rh_flowToSetup = get_rh_flowToSetup();
    app.get('/some/path', rh_flowToSetup);

    function get_rh_flowToSetupArray() {
        return function rh_flowToSetupArray(req, res) {

        }
    }
    var rh_flowToSetupArray = get_rh_flowToSetupArray();
    app.get('/some/path', [rh_flowToSetupArray]);

    function get_rh_flowToHeuristicSetup() {
        return function rh_flowToHeuristicSetup(req, res) {

        }
    }
    var rh_flowToHeuristicSetup = get_rh_flowToHeuristicSetup();
    unknownApp.get('/some/path', rh_flowToHeuristicSetup)
}

function adHocTestsFor_HeuristicRouteSetups_withTracking() {
    function get_rh() {
        return function rh(req, res) {

        }
    }
    var rh = get_rh();
    app.get('/some/path', rh);

    unknownApp.get('/some/path', rh);

    unknownApp.get('/some/path', [rh]);

    unknownApp.get('/some/path', unknown);

    unknownApp.get('/some/path', [unknown]);

    unknownApp.get('/some/path', unknown, rh);
}
