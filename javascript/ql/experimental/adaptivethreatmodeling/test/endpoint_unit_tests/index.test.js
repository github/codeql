/*
 * There's unit tests in this file, so we should mark any non-Sink, non-NotASink endpoints within it
 * as LikelyNotASink.
 */
describe('Unit test suite', () => {
  it('not flow from source', () => {
    User.find({ 'isAdmin': true });
    expect(true).toBe(true);
  });
});
