$("button").click(function () {
    var target = $(this).attr("data-target");
	$.find(target).hide();
});
