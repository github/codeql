import { combineReducers } from 'redux';

export default (state, action) => {
    return state;
};

export function notAReducer(notState, notAction) {
    console.log(notState, notAction);
}

export const nestedReducer = combineReducers({
    inner: (state, action) => state
});
