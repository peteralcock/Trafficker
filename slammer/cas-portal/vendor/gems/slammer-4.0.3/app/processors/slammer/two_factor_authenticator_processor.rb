require 'rotp'

module Slammer::TwoFactorAuthenticatorProcessor
  extend ActiveSupport::Concern

  def validate_one_time_password(otp, authenticator)
    if authenticator.nil? || authenticator.expired?
      Slammer::ValidationResult.new 'INVALID_AUTHENTICATOR', 'Authenticator does not exist or expired', :warn
    else
      totp = ROTP::TOTP.new(authenticator.secret)
      if totp.verify_with_drift(otp, Slammer.config.two_factor_authenticator[:drift])
        Slammer::ValidationResult.new
      else
        Slammer::ValidationResult.new 'INVALID_OTP', 'One-time password not valid', :warn
      end
    end
  end
end
