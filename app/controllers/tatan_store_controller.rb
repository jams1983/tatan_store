# frozen_string_literal: true

class TatanStoreController < ApplicationController
  before_action :authenticate_user!
end
