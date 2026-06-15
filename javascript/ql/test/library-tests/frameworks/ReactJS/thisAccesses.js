class C extends React.Component {
    constructor () {
        this;

        var dis = this;
        dis.p;

        (function () {
            this;
        }).bind(this);
    }

    someInstanceMethod() {
        this;
    }
} // $ reactComponent

React.createClass({
    render: function() {
        (function () {
            this;
        }).bind(this);
        return <div/>;
    },

    someInstanceMethod: function() {
        this;
    }
}); // $ reactComponent

(function (props) { // $ threatModelSource=view-component-input
    (function () {
        this; props;
    }).bind(this);
    return <div/>;
}) // $ reactComponent

React.createClass({
    render: function() {
        React.Children.map(whatEver, function () {
            this;
        }, this)
        return <div/>;
    },
}); // $ reactComponent

class C2 extends React.Component {
    constructor (y) { // $ threatModelSource=view-component-input
        this.state = x;
        this.state = y;
    }
} // $ reactComponent

class C3 extends React.Component {
    constructor() {

    }

    render() {
        var foo = <this.name></this.name>;
        var bar = <this.this></this.this>;
    }
} // $ reactComponent
