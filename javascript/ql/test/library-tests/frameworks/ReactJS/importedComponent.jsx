import { MyComponent } from "./exportedComponent";

export function render({color, location}) { // $ threatModelSource=view-component-input locationSource threatModelSource=remote
    return <MyComponent color={color}/> // $ getACandidatePropsValue
} // $ reactComponent
