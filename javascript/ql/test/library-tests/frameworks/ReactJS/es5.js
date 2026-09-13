var Hello = React.createClass({ // $ reactComponent
  displayName: 'Hello',
  render: function() {
    return <div>Hello {this.props.name}</div>; // $ threatModelSource=view-component-input
  },
  getDefaultProps: function() {
    return {
      name: 'world' // $ getACandidatePropsValue
    };
  }
});

Hello.info = function() {
  return "Nothing to see here.";
};

var createReactClass = require('create-react-class');
var Greeting = createReactClass({ // $ reactComponent
  render: function() {
    return <h1>Hello, {this.props.name}</h1>; // $ threatModelSource=view-component-input
  }
});
