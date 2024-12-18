class UserController < ActionController::Base
    def create
        # GOOD: the permitted parameters are explicitly specified
        User.new(user_params).save!
    end

    def user_params
        params.require(:user).permit(:name, :email)
    end
end