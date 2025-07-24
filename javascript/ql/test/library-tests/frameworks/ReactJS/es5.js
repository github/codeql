var Hello = React.createClass({
  displayName: 'Hello',
  render: function() {
    return <div>Hello {this.props.name}</div>; // $ threatModelSource=view-component-input
  },
  getDefaultProps: function() {
    return {
      name: 'world' // $ getACandidatePropsValue
    };
  }
}); // $ reactComponent

Hello.info = function() {
  return "Nothing to see here.";
};

var createReactClass = require('create-react-class');
var Greeting = createReactClass({
  render: function() {
    return <h1>Hello, {this.props.name}</h1>; // $ threatModelSource=view-component-input
  }
}); // $ reactComponent
