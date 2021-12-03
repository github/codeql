import React from 'react';
import _ from 'lodash';

React.createClass({
    render: function() {
        React.Children.map(whatEver, function () {
            this;
        }, this)
        _.map(whatEver, function () {
            this;
        }, this)

        return <div/>;
    },
});
