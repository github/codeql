// This file contains a lot of trivial reducers and actions, simply to test that
// the Redux model recognizes them, but no data flow passes through them.

const toolkitAction = require('@reduxjs/toolkit').createAction('counter/increment');
const toolkitAsyncAction = require('@reduxjs/toolkit').createAsyncThunk('async-action', async (arg) => {
    return await (await fetch(arg)).json();
})

const reduxCombine = require('redux').combineReducers({
    foo: (state, action) => state,
    bar: {
        baz: (state, action) => state,
    }
});
const immutableCombine = require('redux-immutable').combineReducers({
    foo: (state, action) => state,
    bar: {
        baz: (state, action) => state,
    }
});
const toolkitCombine = require('@reduxjs/toolkit').combineReducers({
    foo: (state, action) => state,
    bar: {
        baz: (state, action) => state,
    }
});

const handleActions = require('redux-actions').handleActions({
    fooAction: (state, action) => state,
});

const handleAction = require('redux-actions').handleAction('fooAction', (state, action) => state);

const persistReducer = require('redux-persist').persistReducer((state, action) => state);

const immer = require('immer')((state, action) => state);
const immerProduce = require('immer').produce((state, action) => state);

const reduceReducers1 = require('reduce-reducers')((state, action) => state);
const reduceReducers2 = require('reduce-reducers')([(state, action) => state, reducerReducers1]);
const reduceReducers3 = require('redux-actions').reduceReducers((state, action) => state);
const reduceReducers4 = require('redux-actions').reduceReducers([(state, action) => state, reducerReducers1]);

const createReducer = require('@reduxjs/toolkit').createReducer(0, builder => {
    builder
        .addCase(toolkitAction, (state, action) => state)
        .addCase(toolkitAction, (state, action) => state)
});

function createSlice1() {
    const { increment } = require('@reduxjs/toolkit').createSlice({
        name: 'counter1',
        initialState: 0,
        reducers: {
            increment(state, action) {
                return state;
            }
        },
        extraReducers: {
            [toolkitAction]: (state, action) => {
                return state;
            },
            [toolkitAsyncAction.fulfilled]: (state, action) => {
                action.meta.arg;
                return state;
            },
            [toolkitAsyncAction.rejected]: (state, action) => {
                action.meta.arg;
                return state;
            },
            [toolkitAsyncAction.pending]: (state, action) => {
                action.meta.arg;
                return state;
            }
        }
    });
    return increment;
}

function createSlice2() {
    const { increment } = require('@reduxjs/toolkit').createSlice({
        name: 'counter2',
        initialState: 0,
        reducers: {
            increment(state, action) {
                return state;
            }
        },
        extraReducers: builder => {
            builder
                .addCase(toolkitAction, (state, action) => state)
                .addCase(toolkitAsyncAction.fulfilled, (state, action) => {
                    action.meta.arg;
                    return state;
                });
        }
    });
    return increment;
}

let importedReducers = combineReducers({
    foo: {
        bar: {
            baz: (state, action) => state
        },
        baloon: require('./exportedReducer'),
    },
    nestedReducer: require('./exportedReducer').nestedReducer
});

const reduxActions = require('redux-actions').createAction('reduxActionsCreateAction');
const tsUtils = require('redux-ts-utils').createAction('tsUtilCreateAction');

const { fooAction2, barAction2 } = require('redux-actions').createActions({
    foo1Action2(x, y) {
        return { x, y }
    },
    barAction2(x) {
        return { x }
    }
});

function wrapper(fn) {
    return (state, action) => {
        console.log('hello');
        return fn(state, action);
    }
}
const combinedWrappedReducer = require('redux').combineReducers({
    wrapped: wrapper((state, action) => state),
});

const store1 = require('redux').createStore(combinedWrappedReducer);
const store2 = require('@reduxjs/toolkit').createStore((state, action) => state);
const store3 = require('@reduxjs/toolkit').configureStore({
    reducer: (state, action) => state
});
