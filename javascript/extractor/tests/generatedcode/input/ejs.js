let data1 = <%= user_data1 %>;
let data2 = <%- user_data2 %>;
if (<%something%>) {}
foo(<%bar%>, <%baz%>);

<% generated_code %>
let string = "<%= not_generated_code %>"; // parse as string literal
