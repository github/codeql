import jwt_decode from "jwt-decode";
import $ from "jquery"

$.post(loginUrl(), {data: "foo"}, (data, xhr) => {
    var decoded = jwt_decode(data);
    $.jGrowl(decoded); // NOT OK - but only flagged with additional sources [INCONSISTENCY]
});
