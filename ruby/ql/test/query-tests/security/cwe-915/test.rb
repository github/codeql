class User < ApplicationRecord

end

class UserController < ActionController::Base
    def create
        # BAD: arbitrary params are permitted to be used for this assignment
        User.new(user_params).save!
    end

    def create2
        # GOOD: the permitted parameters are explicitly specified
        User.new(params[:user].permit(:name,:address))
    end

    def user_params
        params.require(:user).permit!
    end
end