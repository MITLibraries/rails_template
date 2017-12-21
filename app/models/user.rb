class User < ApplicationRecord
  if ENV['FAKE_AUTH_ENABLED'] == 'true'
    devise :omniauthable, omniauth_providers: [:developer]
  else
    devise :omniauthable, omniauth_providers: [:mit_oauth2]
  end

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
    end
  end
end
