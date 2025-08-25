function ES2015() {
    class C extends React.Component { // $ threatModelSource=view-component-input
    } // $ reactComponent

    C.defaultProps = { propFromDefaultProps: "propFromDefaultProps" }; // $ getACandidatePropsValue

    (<C propFromJSX={"propFromJSX"}/>); // $ getACandidatePropsValue

    new C({propFromConstructor: "propFromConstructor"}); // $ getACandidatePropsValue
}

function ES5() {
    var C = React.createClass({
        getDefaultProps() {
            return { propFromDefaultProps: "propFromDefaultProps" }; // $ getACandidatePropsValue
        }
    }); // $ reactComponent

    (<C propFromJSX={"propFromJSX"}/>); // $ getACandidatePropsValue

    C({propFromConstructor: "propFromConstructor"}); // $ getACandidatePropsValue

}

function Functional() {
    function C(props) { // $ threatModelSource=view-component-input
        return <div/>;
    } // $ reactComponent

    C.defaultProps = { propFromDefaultProps: "propFromDefaultProps" }; // $ getACandidatePropsValue

    (<C propFromJSX={"propFromJSX"}/>); // $ getACandidatePropsValue

    new C({propFromConstructor: "propFromConstructor"}); // $ getACandidatePropsValue

}
