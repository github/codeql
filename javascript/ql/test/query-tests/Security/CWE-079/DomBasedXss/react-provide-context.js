import { MyContext } from './react-create-context';

export function renderMain() {
    return <MyContext.Provider value={{root: document.body}}></MyContext.Provider>
}
