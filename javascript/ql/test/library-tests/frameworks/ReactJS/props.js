function ES2015() {
    class C extends React.Component {
    }

    C.defaultProps = { propFromDefaultProps: "propFromDefaultProps" };

    (<C propFromJSX={"propFromJSX"}/>);

    new C({propFromConstructor: "propFromConstructor"});
}

function ES5() {
    var C = React.createClass({
        getDefaultProps() {
            return { propFromDefaultProps: "propFromDefaultProps" };
        }
    });

    (<C propFromJSX={"propFromJSX"}/>);

    C({propFromConstructor: "propFromConstructor"});

}

function Functional() {
    function C(props) {
        return <div/>;
    }

    C.defaultProps = { propFromDefaultProps: "propFromDefaultProps" };

    (<C propFromJSX={"propFromJSX"}/>);

    new C({propFromConstructor: "propFromConstructor"});

}
