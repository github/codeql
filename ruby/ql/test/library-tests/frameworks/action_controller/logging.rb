class UsersController < ActionController::Base
    def index
        logger.info "some info"
        logger.warn "a warning"
        logger.debug request.params
        l = logger
        l.info "more info"
    end
end
