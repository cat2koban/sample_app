require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe 'GET /login' do
    it { is_expected.to eq(200) }
  end
end
