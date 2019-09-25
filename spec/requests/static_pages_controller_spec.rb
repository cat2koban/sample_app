require 'rails_helper'

RSpec.describe StaticPagesController, type: :request do
  describe "GET /" do
    it "Home ページの取得" do
      is_expected.to eq(200)
      expect(response.body).to include(full_title(""))
    end
  end

  describe "GET /help" do
    it "タイトルに Help が含まれている" do
      is_expected.to eq(200)
      expect(response.body).to include(full_title("Help"))
    end
  end

  describe "GET /about" do
    it "タイトルに About が含まれている" do
      is_expected.to eq(200)
      expect(response.body).to include(full_title("About"))
    end
  end

  describe "GET /contact" do
    it "タイトルに Contact が含まれている" do
      is_expected.to eq(200)
      expect(response.body).to include(full_title("Contact"))
    end
  end
end
