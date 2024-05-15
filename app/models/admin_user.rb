# frozen_string_literal: true

class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable, :trackable

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at current_sign_in_at email id sign_in_count updated_at]
  end
end
