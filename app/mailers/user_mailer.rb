class UserMailer < ApplicationMailer
  def welcome_email(user, verification_code)
    @user = user
    @verification_code = verification_code
    mail(to: @user.email, subject: 'Welcome to our app!')
  end
end
