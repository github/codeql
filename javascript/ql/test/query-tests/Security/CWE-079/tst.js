function test() {
  var target = document.location.search

  // NOT OK
  $('myId').html(target)

  // NOT OK
  document.write("<OPTION value=1>"+document.location.href.substring(document.location.href.indexOf("default=")+8)+"</OPTION>");
  document.write("<OPTION value=2>English</OPTION>");

  // NOT OK
  $('<div style="width:' + target + 'px">');

  $('<div style="width:' + +target + 'px">'); // OK
  $('<div style="width:' + parseInt(target) + 'px">'); // OK

  let params = (new URL(document.location)).searchParams;
  $('name').html(params.get('name'));  // NOT OK

  var searchParams = new URLSearchParams(target.substring(1));
  $('name').html(searchParams.get('name')); // NOT OK
}

function foo(target) {
 // NOT OK
  $('myId').html(target);
}
foo(document.location.search);

function bar() {
  return document.location.search;
}
// NOT OK
$('myId').html(bar());

function baz(x) {
  return x;
}
// NOT OK
$('myId').html(baz(document.location.search));

function wrap(s) {
  return "<div>" + s + "</div>";
}
// NOT OK
$('myId').html(wrap(document.location.search));

function chop(s) {
  if (s)
    return s.substr(1);
  return "";
}
// NOT OK
$('myId').html(chop(document.location.search));
// NOT OK (duplicated to test precision of flow tracking)
$('myId').html(chop(document.location.search));
// NOT OK
$('myId').html(wrap(chop(bar())));

function dangerouslySetInnerHtml(s) {
  // NOT OK
  $('myId').html(s);
}
dangerouslySetInnerHtml(document.location.search);
dangerouslySetInnerHtml(document.location.search);

// NOT OK
$('myId').html(bar());

[,document.location.search].forEach(function(x) {
  if (x)
    // NOT OK
    $('myId').html(x);
});

// NOT OK
let s = <span dangerouslySetInnerHTML={{__html: document.location.search}}/>;

angular.module('myApp', [])
    .service("myService", function($sce, $other) {
        $sce.trustAsHtml(document.location.search); // NOT OK
        $sce.trustAsCss(document.location.search); // NOT OK
        $sce.trustAsUNKNOWN(document.location.search); // OK
        $sce.trustAs($sce.HTML, document.location.search); // NOT OK
        $sce.trustAs($sce.CSS, document.location.search); // NOT OK
        $sce.trustAs(UNKNOWN, document.location.search); // OK
        $other.trustAsHtml(document.location.search); // OK
    })
    .service("myService2", function() {
        angular.element('<div>').html(document.location.search); // NOT OK
        angular.element('<div>').html('SAFE'); // OK
    })
    .directive('myCustomer', function() {
        return {
            link: function(scope, element){
                element.html(document.location.search); // NOT OK
                element.html('SAFE'); // OK
            }
        };
    })
    .service("myService3", function() {
        angular.element(document.location.search); // NOT OK
        angular.element('SAFE'); // OK
    })

function tst() {
  var v = document.location.search.substr(1);

  // NOT OK
  document.write(v);

  if (/^\d+$/.test(v)) {
    // OK
    document.write(v);
  }

  if ((m = /^\d+$/.exec(v))) {
    // OK
    document.write(v);
  }

  if (v.match(/^\d+$/)) {
      // OK
      document.write(v);
  }

  if (v.match("^\\d+$")) {
      // OK
      document.write(v);
  }

  if (!(/\d+/.test(v))) // not effective - matches "123<script>...</script>"
    return;

  // NOT OK
  document.write(v);

  if (!(/^\d+$/.test(v)))
    return;

  // OK
  document.write(v);
}

function angularJSServices() {
    angular.module('myApp', [])
        .factory("xssSource_to_service", ["xssSinkService1", function(xssSinkService1) {
            xssSinkService1(window.location.search);
        }])
        .factory("xssSinkService1", function(){
            return function(v){ $("<div>").html(v); } // NOT OK
        })

        .factory("xssSource_from_service", ["xssSourceService", function(xssSourceService){
            $("<div>").html(xssSourceService()); // NOT OK
        }])
        .factory("xssSourceService", function(){
            return function() { return window.location.search };
        })

        .factory("innocentSource_to_service", ["xssSinkService2", function(xssSinkService2) {
            xssSinkService2("innocent");
        }])
        .factory("xssSinkService2", function(){
            return function(v){ $("<div>").html(v); } // OK
        })

        .factory("innocentSource_from_service", ["innocentSourceService", function(innocentSourceService){
            $("<div>").html(innocentSourceService()); // OK
        }])
        .factory("innocentSourceService", function(){
            return function() { return "innocent" };
        })
}

function testDOMParser() {
    var target = document.location.search

    var parser = new DOMParser();
    parser.parseFromString(target, "application/xml"); // NOT OK
}

function references() {
    var tainted = document.location.search;

    document.body.innerHTML = tainted; // NOT OK

    document.createElement().innerHTML = tainted; // NOT OK
    createElement().innerHTML = tainted; // NOT OK

    document.getElementsByClassName()[0].innerHTML = tainted; // NOT OK
    getElementsByClassName()[0].innerHTML = tainted; // NOT OK
    getElementsByClassName().item().innerHTML = tainted; // NOT OK
}

function react(){
    var tainted = document.location.search;

    React.createElement("div", {dangerouslySetInnerHTML: {__html: tainted}}); // NOT OK
    React.createFactory("div")({dangerouslySetInnerHTML: {__html: tainted}}); // NOT OK

    class C1 extends React.Component {
        constructor() {
            this.state.tainted1 = tainted;
            this.state.notTainted = dbLookup();
            this.setState(() => ({ tainted2: tainted }))
            this.state = { tainted3: tainted }
            this.state.tainted4 = tainted;
        }

        test() {
            $('myId').html(this.state.tainted1); // NOT OK
            $('myId').html(this.state.tainted2); // NOT OK
            $('myId').html(this.state.tainted3); // NOT OK
            $('myId').html(this.state.notTainted); // OK

            this.setState(prevState => {
                $('myId').html(prevState.tainted4) // NOT OK
            });
        }
    }

    class C2 extends React.Component {
        test() {
            $('myId').html(this.props.tainted1); // NOT OK
            $('myId').html(this.props.tainted2); // NOT OK
            $('myId').html(this.props.tainted3); // NOT OK
            $('myId').html(this.props.notTainted); // OK

            this.setState((prevState, prevProps) => {
                $('myId').html(prevProps.tainted4) // NOT OK
            });
        }
    }

    C2.defaultProps = { tainted1: tainted };

    (<C2 tainted2={tainted}/>);

    new C2({tainted3: tainted});
    new C2({tainted4: tainted});

    // realistic example
    class C3 extends React.Component {
        constructor(props) {
            super(props);
            this.state.stateTainted = props.propTainted;
        }

        render() {
            return <span dangerouslySetInnerHTML={{__html: this.state.stateTainted}}/>;
        }
    }

    (<C3 propTainted={tainted}/>);
}

function windowName() {
    $(window.name); // NOT OK
    $(name); // NOT OK
}
function windowNameAssigned() {
    for (name of ['a', 'b']) {
        $(window.name); // NOT OK
        $(name); // OK
    }
}

function jqueryLocation() {
    $(location); // OK
    $(window.location); // OK
    $(document.location); // OK
    var loc1 = location;
    var loc2 = window.location;
    var loc3 = document.location;
    $(loc1); // OK
    $(loc2); // OK
    $(loc3); // OK

    $("body").append(location); // NOT OK
}


function testCreateContextualFragment() {
    var tainted = window.name;
    var range = document.createRange();
    range.selectNode(document.getElementsByTagName("div").item(0));
    var documentFragment = range.createContextualFragment(tainted); // NOT OK
    document.body.appendChild(documentFragment);
}

function flowThroughPropertyNames() {
    var obj = {};
    obj[Math.random()] = window.name;
    for (var p in obj)
      $(p); // OK
}

function basicExceptions() {
	try {
		throw location;
	} catch(e) {
		$("body").append(e); // NOT OK
	}

	try {
		try {
			throw location
		} finally {}
	} catch(e) {
		$("body").append(e); // NOT OK
	}
}

function handlebarsSafeString() {
	return new Handlebars.SafeString(location); // NOT OK!	
}

function test2() {
  var target = document.location.search

  // OK
  $('myId').html(target.length)
}

function getTaintedUrl() {
  return new URL(document.location);
}

function URLPseudoProperties() {
  let params = getTaintedUrl().searchParams;
  $('name').html(params.get('name')); // NOT OK

  let myUrl = getTaintedUrl();
  $('name').html(myUrl.get('name')); // OK (.get is not defined on a URL)
}


function hash() {
  function getUrl() {
    return new URL(document.location);
  }
  $(getUrl().hash.substring(1)); // NOT OK

}

function growl() {
  var target = document.location.search
  $.jGrowl(target); // NOT OK
}

function thisNodes() {
	var pluginName = "myFancyJQueryPlugin";
	var myPlugin = function () {
	    var target = document.location.search
	    this.html(target); // NOT OK. (this is a jQuery object)
		this.innerHTML = target // OK. (this is a jQuery object)
	
		this.each(function (i, e) {
			this.innerHTML = target; // NOT OK. (this is a DOM-node);
			this.html(target); // OK. (this is a DOM-node);
			
			e.innerHTML = target; // NOT OK.
		});
	}
	$.fn[pluginName] = myPlugin; 

}

function test() {
  var target = document.location.search

  // NOT OK
  $('myId').html(target)

  // OK
  $('myid').html(document.location.href.split("?")[0]);
}

function test() {
  var target = document.location.search

  
  $('myId').html(target); // NOT OK

  $('myId').html(target.taint); // NOT OK

  target.taint2 = 2;
  $('myId').html(target.taint2); // OK

  target.taint3 = document.location.search;
  $('myId').html(target.taint3); // NOT OK

  target.sub.taint4 = 2
  $('myId').html(target.sub.taint4); // OK

  $('myId').html(target.taint5); // NOT OK
  target.taint5 = "safe";

  target.taint6 = 2;
  if (random()) {return;}
  $('myId').html(target.taint6); // OK

  
  if (random()) {target.taint7 = "safe";}
  $('myId').html(target.taint7); // NOT OK

  target.taint8 = target.taint8;
  $('myId').html(target.taint8); // NOT OK

  target.taint9 = (target.taint9 = "safe");
  $('myId').html(target.taint9); // OK
}

function hash2() {
  var payload = window.location.hash.substr(1);
  document.write(payload); // NOT OK

  let match = window.location.hash.match(/hello (\w+)/);
  if (match) {
    document.write(match[1]); // NOT OK
  }

  document.write(window.location.hash.split('#')[1]); // NOT OK
}
