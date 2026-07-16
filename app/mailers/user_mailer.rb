class UserMailer < ApplicationMailer
  default from: 'bienvenue@odinbook.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/users/sign_in'
    mail(to: @user.email, subject: 'Bienvenue sur Odinbook !')
  end
end
