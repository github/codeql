class MyMailer < ActionMailer::Base
  def foo
    sink params[:foo] # $hasTaintFlow
  end
end
