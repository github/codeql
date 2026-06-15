(function () {
	$("#id").html($("textarea").val()); // $ Alert
	
	$("#id").html($(".some-element").text()); // $ Alert
	
	$("#id").html($(".some-element").attr("foo", "bar"));
	$("#id").html($(".some-element").attr({"foo": "bar"}));
	$("#id").html($(".some-element").attr("data-target")); // $ Alert
	
	$("#id").html(
		document.getElementById("foo").innerText // $ Alert
	);
	
	$("#id").html(
		document.getElementById("foo").innerHTML // OK - only repeats existing XSS.
	);
	
	$("#id").html(
		document.getElementById("foo").textContent // $ Alert
	);
	
	$("#id").html(
		document.querySelectorAll("textarea")[0].value // $ Alert
	);
	
	$("#id").html(
		document.getElementById('div1').getAttribute('data-target') // $ Alert
	);
	
	function safe1(x) { // overloaded function. 
		if (x.jquery) {
			var foo = $(x);
		}
		 	
	}
	safe1($("textarea").val());
	
	function safe2(x) { // overloaded function. 
		if (typeof x === "object") {
			var foo = $(x);
		} 	
	}
	safe2($("textarea").val());
	

	$("#id").html(
		$("<p>" + something() + "</p>").text() // OK - this is for a flow-step to catch, not this query.
	);
	
	
	$("#id").get(0).innerHTML = $("textarea").val(); // $ Alert
	
	var base = $("#id");
	base[html ? 'html' : 'text']($("textarea").val()); // $ Alert
	
	$("#id").get(0).innerHTML = $("input").get(0).name; // $ Alert
	$("#id").get(0).innerHTML = $("input").get(0).getAttribute("name"); // $ Alert
	
	$("#id").get(0).innerHTML = $("input").getAttribute("id");
	
	$("#id").get(0).innerHTML = $(document).find("option").attr("value"); // $ Alert
	
	var valMethod = $("textarea").val;
	$("#id").get(0).innerHTML = valMethod(); // $ Alert
	
	var myValue = $(document).find("option").attr("value");
	if(myValue.property) {
		$("#id").get(0).innerHTML = myValue;
	}
	
	$.jGrowl($("input").get(0).name); // $ Alert
	
    let selector = $("input").get(0).name; // $ Source
    if (something()) {
        selector = $("textarea").val || ''
    }
	$(selector); // $ Alert
	
	$(document.my_form.my_input.value); // $ Alert

	$("#id").html( $('#foo').prop('innerText') ); // $ Alert

	const anser = require("anser");
	const text = $("text").text(); // $ Source

	$("#id").html(anser.ansiToHtml(text)); // $ Alert
	$("#id").html(new anser().process(text)); // $ Alert
	
	$("section h1").each(function(){
		$("nav ul").append("<a href='#" + $(this).text().toLowerCase().replace(/ /g, '-').replace(/[^\w-]+/g,'') + "'>Section</a>");
	});

	$("#id").html($("#foo").find(".bla")[0].value); // $ Alert

	for (var i = 0; i < foo.length; i++) {
		$("#id").html($("#foo").find(".bla")[i].value); // $ Alert
	}
})();

class Super {
	constructor() {
		this.el = $("#id").get(0);
	}
}

class Sub extends Super {
	constructor() {
		super();
		$("#id").get(0).innerHTML = "<a src=\"" + this.el.src + "\">foo</a>"; // $ Alert - Attack: `<mytag id="id" src="x:&quot;&gt;&lt;img src=1 onerror=&quot;alert(1)&quot;&gt;" />`
	}
}

(function () {
    const src = document.getElementById("#link").src; // $ Source
	$("#id").html(src); // $ Alert

    $("#id").attr("src", src);

    $("input.foo")[0].onchange = function (ev) {
        $("#id").html(ev.target.files[0].name); // $ Alert

        $("img#id").attr("src", URL.createObjectURL(ev.target.files[0])); // $ Alert
    }
})();

(function () {
	let elem = document.createElement('a');
	const wSelection = getSelection();
	const dSelection = document.getSelection();
	let linkText = wSelection.toString() || dSelection.toString() || ''; // $ Source
	elem.innerHTML = linkText; // $ Alert
	$("#id").html(linkText); // $ Alert
	elem.innerText = linkText;
})();

const cashDom = require("cash-dom");

(function () {
    const src = document.getElementById("#link").src; // $ Source
	cash("#id").html(src); // $ Alert
    cashDom("#id").html(src); // $ Alert

    var DOMPurify = {
        sanitize: function (src) {
            return src; // to model spuriously finding an edge. The below is still OK.
        }
    };
    cashDom("#id").html(DOMPurify ? DOMPurify.sanitize(src) : src);

    $("<a />", { html: src }).appendTo("#id"); // $ Alert

    function foo() {
      window.VeryUniqueXssTestName = {
        send: function (msg) {
            $("#id").html(msg); // $ Alert
        },
      };
    
      VeryUniqueXssTestName.send($("textarea").val()); // $ Source
    }
    foo()
})();