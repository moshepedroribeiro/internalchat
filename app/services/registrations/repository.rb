module Registrations
  class Repository
    def self.get_user_by_email(email)
      User.where(email: email).first
    end
  end
end

