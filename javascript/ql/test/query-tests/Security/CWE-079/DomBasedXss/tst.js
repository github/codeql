function test() {
  var target = document.location.search // $ Source

  $('myId').html(target) // $ Alert

  document.write("<OPTION value=1>"+document.location.href.substring(document.location.href.indexOf("default=")+8)+"</OPTION>"); // $ Alert
  document.write("<OPTION value=2>English</OPTION>");

  $('<div style="width:' + target + 'px">'); // $ Alert

  $('<div style="width:' + +target + 'px">');
  $('<div style="width:' + parseInt(target) + 'px">');

  let params = (new URL(document.location)).searchParams; // $ Source
  $('name').html(params.get('name'));  // $ Alert

  var searchParams = new URLSearchParams(target.substring(1));
  $('name').html(searchParams.get('name')); // $ Alert
}

function foo(target) {
  $('myId').html(target); // $ Alert
}
foo(document.location.search); // $ Source

function bar() {
  return document.location.search; // $ Source
}
$('myId').html(bar()); // $ Alert

function baz(x) {
  return x;
}
$('myId').html(baz(document.location.search)); // $ Alert

function wrap(s) {
  return "<div>" + s + "</div>";
}
$('myId').html(wrap(document.location.search)); // $ Alert

function chop(s) {
  if (s)
    return s.substr(1);
  return "";
}
$('myId').html(chop(document.location.search)); // $ Alert
$('myId').html(chop(document.location.search)); // $ Alert - duplicated to test precision of flow tracking
$('myId').html(wrap(chop(bar()))); // $ Alert

function dangerouslySetInnerHtml(s) {
  $('myId').html(s); // $ Alert
}
dangerouslySetInnerHtml(document.location.search); // $ Source
dangerouslySetInnerHtml(document.location.search); // $ Source

$('myId').html(bar()); // $ Alert

[,document.location.search].forEach(function(x) { // $ Source
  if (x)
    $('myId').html(x); // $ Alert
});

let s = <span dangerouslySetInnerHTML={{__html: document.location.search}}/>; // $ Alert

angular.module('myApp', [])
    .service("myService", function($sce, $other) {
        $sce.trustAsHtml(document.location.search); // $ Alert
        $sce.trustAsCss(document.location.search); // $ Alert
        $sce.trustAsUNKNOWN(document.location.search);
        $sce.trustAs($sce.HTML, document.location.search); // $ Alert
        $sce.trustAs($sce.CSS, document.location.search); // $ Alert
        $sce.trustAs(UNKNOWN, document.location.search);
        $other.trustAsHtml(document.location.search);
    })
    .service("myService2", function() {
        angular.element('<div>').html(document.location.search); // $ Alert
        angular.element('<div>').html('SAFE');
    })
    .directive('myCustomer', function() {
        return {
            link: function(scope, element){
                element.html(document.location.search); // $ Alert
                element.html('SAFE');
            }
        };
    })
    .service("myService3", function() {
        angular.element(document.location.search); // $ Alert
        angular.element('SAFE');
    })

function tst() {
  var v = document.location.search.substr(1); // $ Source

  document.write(v); // $ Alert

  if (/^\d+$/.test(v)) {

    document.write(v);
  }

  if ((m = /^\d+$/.exec(v))) {

    document.write(v);
  }

  if (v.match(/^\d+$/)) {

      document.write(v);
  }

  if (v.match("^\\d+$")) {

      document.write(v);
  }

  if (!(/\d+/.test(v))) // not effective - matches "123<script>...</script>"
    return;

  document.write(v); // $ Alert

  if (!(/^\d+$/.test(v)))
    return;


  document.write(v);
}

function angularJSServices() {
    angular.module('myApp', [])
        .factory("xssSource_to_service", ["xssSinkService1", function(xssSinkService1) {
            xssSinkService1(window.location.search); // $ Source
        }])
        .factory("xssSinkService1", function(){
            return function(v){ $("<div>").html(v); } // $ Alert
        })

        .factory("xssSource_from_service", ["xssSourceService", function(xssSourceService){
            $("<div>").html(xssSourceService()); // $ Alert
        }])
        .factory("xssSourceService", function(){
            return function() { return window.location.search }; // $ Source
        })

        .factory("innocentSource_to_service", ["xssSinkService2", function(xssSinkService2) {
            xssSinkService2("innocent");
        }])
        .factory("xssSinkService2", function(){
            return function(v){ $("<div>").html(v); }
        })

        .factory("innocentSource_from_service", ["innocentSourceService", function(innocentSourceService){
            $("<div>").html(innocentSourceService());
        }])
        .factory("innocentSourceService", function(){
            return function() { return "innocent" };
        })
}

function testDOMParser() {
    var target = document.location.search // $ Source

    var parser = new DOMParser();
    parser.parseFromString(target, "application/xml"); // $ Alert
}

function references() {
    var tainted = document.location.search; // $ Source

    document.body.innerHTML = tainted; // $ Alert

    document.createElement().innerHTML = tainted; // $ Alert
    createElement().innerHTML = tainted; // $ Alert

    document.getElementsByClassName()[0].innerHTML = tainted; // $ Alert
    getElementsByClassName()[0].innerHTML = tainted; // $ Alert
    getElementsByClassName().item().innerHTML = tainted; // $ Alert
}

function react(){
    var tainted = document.location.search; // $ Source

    React.createElement("div", {dangerouslySetInnerHTML: {__html: tainted}}); // $ Alert
    React.createFactory("div")({dangerouslySetInnerHTML: {__html: tainted}}); // $ Alert

    class C1 extends React.Component {
        constructor() {
            this.state.tainted1 = tainted;
            this.state.notTainted = dbLookup();
            this.setState(() => ({ tainted2: tainted }))
            this.state = { tainted3: tainted }
            this.state.tainted4 = tainted;
        }

        test() {
            $('myId').html(this.state.tainted1); // $ Alert
            $('myId').html(this.state.tainted2); // $ Alert
            $('myId').html(this.state.tainted3); // $ Alert
            $('myId').html(this.state.notTainted);

            this.setState(prevState => {
                $('myId').html(prevState.tainted4) // $ Alert
            });
        }
    }

    class C2 extends React.Component {
        test() {
            $('myId').html(this.props.tainted1); // $ Alert
            $('myId').html(this.props.tainted2); // $ Alert
            $('myId').html(this.props.tainted3); // $ Alert
            $('myId').html(this.props.notTainted);

            this.setState((prevState, prevProps) => {
                $('myId').html(prevProps.tainted4) // $ Alert
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
            return <span dangerouslySetInnerHTML={{__html: this.state.stateTainted}}/>; // $ Alert
        }
    }

    (<C3 propTainted={tainted}/>);
}

function windowName() {
    $(window.name); // $ Alert
    $(name); // $ Alert
}
function windowNameAssigned() {
    for (name of ['a', 'b']) {
        $(window.name); // $ Alert
        $(name);
    }
}

function jqueryLocation() {
    $(location);
    $(window.location);
    $(document.location);
    var loc1 = location;
    var loc2 = window.location;
    var loc3 = document.location;
    $(loc1);
    $(loc2);
    $(loc3);

    $("body").append(location); // $ Alert
}


function testCreateContextualFragment() {
    var tainted = window.name; // $ Source
    var range = document.createRange();
    range.selectNode(document.getElementsByTagName("div").item(0));
    var documentFragment = range.createContextualFragment(tainted); // $ Alert
    document.body.appendChild(documentFragment);
}

function flowThroughPropertyNames() {
    var obj = {};
    obj[Math.random()] = window.name;
    for (var p in obj)
      $(p);
}

function basicExceptions() {
	try {
		throw location; // $ Source
	} catch(e) {
		$("body").append(e); // $ Alert
	}

	try {
		try {
			throw location // $ Source
		} finally {}
	} catch(e) {
		$("body").append(e); // $ Alert
	}
}

function handlebarsSafeString() {
	return new Handlebars.SafeString(location); // $ Alert
}

function test2() {
  var target = document.location.search


  $('myId').html(target.length)
}

function getTaintedUrl() {
  return new URL(document.location); // $ Source
}

function URLPseudoProperties() {
  let params = getTaintedUrl().searchParams;
  $('name').html(params.get('name')); // $ Alert

  let myUrl = getTaintedUrl();
  $('name').html(myUrl.get('name')); // OK - .get is not defined on a URL
}


function hash() {
  function getUrl() {
    return new URL(document.location); // $ Source
  }
  $(getUrl().hash.substring(1)); // $ Alert

}

function growl() {
  var target = document.location.search // $ Source
  $.jGrowl(target); // $ Alert
}

function thisNodes() {
	var pluginName = "myFancyJQueryPlugin";
	var myPlugin = function () {
	    var target = document.location.search // $ Source
	    this.html(target); // $ Alert - this is a jQuery object
		this.innerHTML = target // OK - this is a jQuery object

		this.each(function (i, e) {
			this.innerHTML = target; // $ Alert - this is a DOM-node
			this.html(target); // OK - this is a DOM-node

			e.innerHTML = target; // $ Alert
		});
	}
	$.fn[pluginName] = myPlugin;

}

function test() {
  var target = document.location.search // $ Source

  $('myId').html(target) // $ Alert

  // OK - but only safe because contents are URI-encoded
  $('myid').html(document.location.href.split("?")[0]);
}

function test() {
  var target = document.location.search // $ Source


  $('myId').html(target); // $ Alert

  $('myId').html(target.taint); // $ Alert

  target.taint2 = 2;
  $('myId').html(target.taint2);

  target.taint3 = document.location.search; // $ Source
  $('myId').html(target.taint3); // $ Alert

  target.sub.taint4 = 2
  $('myId').html(target.sub.taint4);

  $('myId').html(target.taint5); // $ Alert
  target.taint5 = "safe";

  target.taint6 = 2;
  if (random()) {return;}
  $('myId').html(target.taint6);


  if (random()) {target.taint7 = "safe";}
  $('myId').html(target.taint7); // $ Alert

  target.taint8 = target.taint8;
  $('myId').html(target.taint8); // $ Alert

  target.taint9 = (target.taint9 = "safe");
  $('myId').html(target.taint9);
}

function hash2() {
  var payload = window.location.hash.substr(1); // $ Source
  document.write(payload); // $ Alert

  let match = window.location.hash.match(/hello (\w+)/); // $ Source
  if (match) {
    document.write(match[1]); // $ Alert
  }

  document.write(window.location.hash.split('#')[1]); // $ Alert
}

function nonGlobalSanitizer() {
  var target = document.location.search // $ Source

  $("#foo").html(target.replace(/<metadata>[\s\S]*<\/metadata>/, '<metadata></metadata>')); // $ Alert

  $("#foo").html(target.replace(/<|>/g, ''));
}

function mootools(){
	var source = document.location.search; // $ Source

	new Element("div");
	new Element("div", {text: source});
	new Element("div", {html: source}); // $ Alert
	new Element("div").set("html", source); // $ Alert
	new Element("div").set({"html": source}); // $ Alert
	new Element("div").setProperty("html", source); // $ Alert
	new Element("div").setProperties({"html": source}); // $ Alert
	new Element("div").appendHtml(source); // $ Alert
}


const Convert = require('ansi-to-html');
const ansiToHtml = new Convert();

function ansiToHTML() {
  var source = document.location.search; // $ Source

  $("#foo").html(source); // $ Alert
  $("#foo").html(ansiToHtml.toHtml(source)); // $ Alert
}

function domMethods() {
	var source = document.location.search; // $ Source

  let table = document.getElementById('mytable');
  table.innerHTML = source; // $ Alert
  let row = table.insertRow(-1);
  row.innerHTML = source; // $ Alert
  let cell = row.insertCell();
  cell.innerHTML = source; // $ Alert
}

function urlStuff() {
  var url = document.location.search.substr(1); // $ Source

  $("<a>", {href: url}).appendTo("body"); // $ Alert
  $("#foo").attr("href", url); // $ Alert
  $("#foo").attr({href: url}); // $ Alert
  $("<img>", {src: url}).appendTo("body"); // $ Alert
  $("<a>", {href: win.location.href}).appendTo("body");

  $("<img>", {src: "http://google.com/" + url}).appendTo("body");

  $("<img>", {src: ["http://google.com", url].join("/")}).appendTo("body");

  if (url.startsWith("https://")) {
    $("<img>", {src: url}).appendTo("body");
  } else {
    $("<img>", {src: url}).appendTo("body"); // $ Alert
  }

  window.open(location.hash.substr(1)); // OK - any JavaScript is executed in another context

  navigation.navigate(location.hash.substr(1)); // $ Alert

  const myHistory = require('history').createBrowserHistory();
  myHistory.push(location.hash.substr(1)); // $ Alert
}

function Foo() {
  this.foo = document;
  var obj = {
    bar: function() {
      this.foo.body.innerHTML = decodeURI(window.location.hash); // $ Alert
    }
  };
  Object.assign(this, obj);
}

function nonGlobalSanitizer() {
  var target = document.location.search // $ Source
  $("#foo").html(target.replace(new RegExp("<|>"), '')); // $ Alert
  $("#foo").html(target.replace(new RegExp("<|>", unknownFlags()), '')); // OK - most likely good. We don't know what the flags are.
  $("#foo").html(target.replace(new RegExp("<|>", "g"), ''));
}

function FooBar() {
  let source = window.name; // $ Source
  $('myId').html(unescape(source)) // $ Alert
}
