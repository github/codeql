class C extends React.Component {
    state = {
        p: 42
    };
}

React.createClass({
  getInitialState: function() {
    return {
      p: 42
    };
  }
});
