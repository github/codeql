    def check_state1(state, interactive=True):
        if not state['good'] or not state['bad']:
            if (good or bad or skip or reset) and interactive:
                return                                          # implicitly return None
            if not state['good']:
                raise util.Abort(_('cannot bisect (no known good revisions)'))
            else:
                raise util.Abort(_('cannot bisect (no known bad revisions)')) 
        return True  							                              
           
    def check_state2(state, interactive=True):
        if not state['good'] or not state['bad']:
            if (good or bad or skip or reset) and interactive:
                return False                                    # return an explicit value
            if not state['good']:
                raise util.Abort(_('cannot bisect (no known good revisions)'))
            else:
                raise util.Abort(_('cannot bisect (no known bad revisions)'))
        return True
