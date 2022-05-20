var Hello = React.createClass({
  displayName: 'Hello',
  render: function() {
    return <div>Hello {this.props.name}</div>;
  },
  getDefaultProps: function() {
    return {
      name: 'world'
    };
  }
});

Hello.info = function() {
  return "Nothing to see here.";
};

var createReactClass = require('create-react-class');
var Greeting = createReactClass({
  render: function() {
    return <h1>Hello, {this.props.name}</h1>;
  }
});
