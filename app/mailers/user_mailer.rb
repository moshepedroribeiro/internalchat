class UserMailer < ApplicationMailer
  def send_confirmation_user_email(email, name, token)
    @name = name
    @email = email
    @token = token

    mail(to: @email, subject: "Confirmação de novo usuário")
  end

  def send_recovery_password_email(email, name, token)
    @name = name
    @email = email
    @token = token

    mail(to: @email, subject: 'Recuperar senha')
  end
end
