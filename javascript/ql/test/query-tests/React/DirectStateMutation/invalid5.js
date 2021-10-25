// The corresponding ESLint test case is commented out
// with the remark "Would be nice to prevent this too"
var Hello = React.createClass({
  render: function() {
    var that = this;
    that.state.person.name.first = "bar"
    return <div>Hello</div>;
  }
});
