import * as e from 'express';
import { Response } from 'express';

/**
 * @param {e.Request} req
 */
function t1(req) { // $ MISSING: hasUnderlyingType='express'.Request SPURIOUS: hasUnderlyingType=e.Request
}

/**
 * @param {Response} res
 */
function t2(res) { // $ MISSING: hasUnderlyingType='express'.Response SPURIOUS: hasUnderlyingType=Response
}
