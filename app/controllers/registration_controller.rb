class RegistrationController < ApplicationController
  def user_registration
    begin
      raw, token = Devise.token_generator.generate(User, :confirmation_token)
      user = User.create!({
                            name: params[:name],
                            email: params[:email],
                            phone: params[:phone],
                            password: params[:password],
                            confirmation_token: token,
                            confirmation_sent_at: Date.current,
                            password_confirmation: params[:password_confirmation]
                          })

      UserMailer.send_confirmation_user_email(user.email, user.name, user.confirmation_token).deliver_now

      render json: {user: user}
    rescue => e
      puts e
      head :internal_server_error
    end
  end

  def confirm_user
    begin
      user = User.where(confirmation_token: params[:token]).first

      if user.present?
        user.confirmed_at = DateTime.current
        user.save!
        render json: {status: 200}
      else
        render json: {status: 400}
      end
    rescue => e
      puts e
      head :internal_server_error
    end
  end

  def recovery_password
    begin
      user = Registrations::Repository.get_user_by_email(params[:email])
      raw, token = Devise.token_generator.generate(User, :confirmation_token)

      if user.present?
        user.reset_password_token = token
        user.reset_password_sent_at = DateTime.current
        user.save
        UserMailer.send_recovery_password_email(user.email, user.name, user.reset_password_token).deliver_now
        render json: {status: 200}
      end

    rescue => e
      puts e
      head 500
    end
  end

  def save_new_password
    begin
      user = User.where(reset_password_token: params[:token]).first

      if user.present?
        if DateTime.current <= (user.reset_password_sent_at + 2.days)
          user.update!({
                         password: params[:password],
                         password_confirmation: params[:password_confirmation]
                       })

          render json: {status: 200}
        else
          render json: {status: 401}
        end
      end
    rescue => e
      puts e
      head 500
    end
  end
end
