(function () {
	$("#id").html($("textarea").val()); // NOT OK.
	
	$("#id").html($(".some-element").text()); // NOT OK.
	
	$("#id").html($(".some-element").attr("foo", "bar")); // OK.
	$("#id").html($(".some-element").attr({"foo": "bar"})); // OK.
	$("#id").html($(".some-element").attr("data-target")); // NOT OK.
	
	$("#id").html(
		document.getElementById("foo").innerText // NOT OK.	
	);
	
	$("#id").html(
		document.getElementById("foo").innerHTML // OK - only repeats existing XSS. 	
	);
	
	$("#id").html(
		document.getElementById("foo").textContent // NOT OK. 	
	);
	
	$("#id").html(
		document.querySelectorAll("textarea")[0].value // NOT OK. 	
	);
	
	$("#id").html(
		document.getElementById('div1').getAttribute('data-target') // NOT OK
	);
	
	function safe1(x) { // overloaded function. 
		if (x.jquery) {
			var foo = $(x); // OK
		}
		 	
	}
	safe1($("textarea").val());
	
	function safe2(x) { // overloaded function. 
		if (typeof x === "object") {
			var foo = $(x); // OK
		} 	
	}
	safe2($("textarea").val());
	

	$("#id").html(
		$("<p>" + something() + "</p>").text() // OK - this is for a flow-step to catch, not this query.
	);
	
	
	$("#id").get(0).innerHTML = $("textarea").val(); // NOT OK.
	
	var base = $("#id");
	base[html ? 'html' : 'text']($("textarea").val()); // NOT OK.
	
	$("#id").get(0).innerHTML = $("input").get(0).name; // NOT OK.
	$("#id").get(0).innerHTML = $("input").get(0).getAttribute("name"); // NOT OK.
	
	$("#id").get(0).innerHTML = $("input").getAttribute("id"); // OK.
	
	$("#id").get(0).innerHTML = $(document).find("option").attr("value"); // NOT OK.
	
	var valMethod = $("textarea").val;
	$("#id").get(0).innerHTML = valMethod(); // NOT OK
	
	var myValue = $(document).find("option").attr("value");
	if(myValue.property) {
		$("#id").get(0).innerHTML = myValue; // OK.
	}
	
	$.jGrowl($("input").get(0).name); // NOT OK.
	
    let selector = $("input").get(0).name;
    if (something()) {
        selector = $("textarea").val || ''
    }
	$(selector); // NOT OK
	
	$(document.my_form.my_input.value); // NOT OK

	$("#id").html( $('#foo').prop('innerText') ); // NOT OK

	const anser = require("anser");
	const text = $("text").text();

	$("#id").html(anser.ansiToHtml(text)); // NOT OK
	$("#id").html(new anser().process(text)); // NOT OK
	
	$("section h1").each(function(){
		$("nav ul").append("<a href='#" + $(this).text().toLowerCase().replace(/ /g, '-').replace(/[^\w-]+/g,'') + "'>Section</a>"); // OK
	});

	$("#id").html($("#foo").find(".bla")[0].value); // NOT OK.

	for (var i = 0; i < foo.length; i++) {
		$("#id").html($("#foo").find(".bla")[i].value); // NOT OK.
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
		$("#id").get(0).innerHTML = "<a src=\"" + this.el.src + "\">foo</a>"; // NOT OK. Attack: `<mytag id="id" src="x:&quot;&gt;&lt;img src=1 onerror=&quot;alert(1)&quot;&gt;" />`
	}
}

(function () {
    const src = document.getElementById("#link").src;
	$("#id").html(src); // NOT OK.

    $("#id").attr("src", src); // OK

    $("input.foo")[0].onchange = function (ev) {
        $("#id").html(ev.target.files[0].name); // NOT OK.

        $("img#id").attr("src", URL.createObjectURL(ev.target.files[0])); // NOT OK
    }
})();
