require 'rails_helper'

RSpec.describe ApplicationHelper do
  include ApplicationHelper

  context 'タイトル表示用ヘルパー' do
    base_title = "Ruby on Rails Tutorial Sample App"
    it 'full_title()' do
      expect(full_title).to eq(base_title)
    end

    it 'full_title("Help")' do
      expect(full_title("Help")).to eq("Help | #{base_title}")
    end
  end
end
