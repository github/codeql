import { Request, Response, wrapper } from './expressWrapperExport';
import * as w from './expressWrapperExport';

function t1(req: Request) { // none
}

function t2(res: Response) { // none
}

function t3(req: wrapper.Request) { // $ hasUnderlyingType='express'.Request
}

function t4(res: wrapper.Response) { // $ hasUnderlyingType='express'.Response
}

function t5(req: w.wrapper.Request) { // $ hasUnderlyingType='express'.Request
}

function t6(res: w.wrapper.Response) { // $ hasUnderlyingType='express'.Response
}

function t7(req: w.Request) { // none
}

function t8(res: w.Response) { // none
}

function t9(e: typeof w.wrapper) { // $ hasUnderlyingType='express'
}
