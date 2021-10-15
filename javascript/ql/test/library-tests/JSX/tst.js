var href = "http://example.com";
var linkTypes = { rel: "noopener noreferrer" };
<a href={href} target="_blank" {...linkTypes}>Link to {href}. {/*TODO: need more exciting link text*/}</a>;
<MyComponents.FancyLink foo="bar"/>;
<Foo/>;     // interpreted as a custom component because of capitalisation
<Foo-Bar/>; // interpreted as an HTML element because of the dash
var fragment = <> fragment text <Foo/> more text </>
