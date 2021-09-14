# Workshop notes for XSS Unsafe jQuery plugin 

## Problem Statement 
- We will be looking at the codebase known as Bootstrap
- Bootstrap makes use of the javascript framework known as jQuery
- jQuery makes it easy to traverse throught the HTML document using documents and send events to the webpage so it provides functionality such as event handling, animation and Ajax calls. 
- It is also extensible, so you can add plugins that extends the functionality 
of what jQuery itself can do 
- Bootstrap uses these plugins in a fairly extensible way 
- It was vulnerable because the plugins that Bootstrap implemented made unsafe use of values provided through user input which led to XSS vulnerabilities
- This is when an attacker can send malicious code (js script) to a different end user
- The core mistake that caused this vulnerability. We have a call to the jQuery `$` function. It is quite powerful and flexible. It can process input and interpret it in different context such as HTML  
- The intent here is that we have some `options` that are provided as a jQuery plugin
- We obtain one of the options in this case `textSrcSelector` and the plugin uses that selector as a CSS selector
- It uses it to decide which HTML elements to look at and then it reads text from them
- That is the intention, but the problem with that is that if you pass this in `$` it will execute JS code if the value of `textSrcSelector` is string. 
- LOOK AT EXAMPLE 
- Therefore we can conclude that the values in options cannot always be trusted and it is dangerous if we pass them into a place like dollar
- In Security terminology those plugin `options` is the source of user input and the argument of `$` is a XSS sink


## SINKS 

### Question 1
- A function call is called a `CallExpr` in JavaScript. In Java it is `MethodAccess`
- Has the standard library already provided this functionality? 

## Question 4 
- Yes we have a `jquery` predicate which can be invoked that handles various complicated forms of aliasing and reimporting 
- Right now we're just querying syntax so the AST
- A data flow node often has a corresponding AST node. You can look at `getAnASTnode` . In our case the `dollarArg` data flow node has a `Expr` AST node
- Look at the `jquery` library and notice that it is inheriting from dataflow

## SOURCES 
- I memtioned jQuery plugins and I care about the `options` to the plugin which can be provided by the outside world
- What do these options look like? Usually reference  `$.fn` and one of its properties in this example is called `copyText` is assigned and the value that is being assigned is a `function() {...}` . That is a plugin - it's something that extends the functionality of jQuery and its options parameter comes from the outside world 
- Now let's focus on finding plugins and their options 

### Question 1 

-Reiterate source we want a property on `$.fn` - it could be called `copyText`, it could be called anything, we're looking for values that are written and any value that is written is esentailly a function so it is assigned   
- Find all places in the code that the property `fn` on `$`
- The javascript library has a lot of local flow so you don't need to reason about indirection and reassignment 
- In the previous question we called `SoureNode.getAPropertyRead()` - this handles the case where `$` when it is first imported might flow to some other place where it gets used and the we refer to the `fn` property on the use
- So let's go back to our source definition - we care when a property is assigned. The property is on `$fn` and there's some value that is assigned to it that might flow into `fn`

### Question 2 
- get `.getAPropertySource` is not longer looking for `$.fn` but instead finding values that are assigned to one of its properties
- We want some node that is assigned to a property of fn and we dont care what that property is as long as it is a property 
- Navigate to `.getAPropertySource` and read through implementation - `result.flowsTo(getAPropertyWrite()` flows to is local data flow. It flows to a place that is a PropertyWrite on the right hand side. PropertyWrite is an assignment and we want the right hand side of that assignment 


### Question 3
- we want the `options` parameter which are the last parameter of these plugins and these are what are coming in from the outside world. Most of the results we're getting back only have one param but in reality there could be more and the options param is usually the last param
- We can see that what is being assigned is functions. We can insist that they are functions by using `FunctionNode`

 
 ## Data Flow 
- We are looking for places that were cross site scripting vulns where a plugin option to jQuery ended up in an argument to `$`
- Data flow is imported as a part of javascript library

 
