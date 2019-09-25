require 'rails_helper'

RSpec.describe 'Site Layout', type: :system do
  describe 'layout links' do
    before do
      visit root_path
    end
    subject { page }

    it 'sample app のリンク先は /' do
      is_expected.to have_link 'sample app', href: root_path
    end

    it 'Home のリンク先は /' do
      is_expected.to have_link 'Home',       href: root_path
    end

    it 'Help のリンク先は /help' do
      is_expected.to have_link 'Help',       href: help_path
    end

    it 'About のリンク先は /about' do
      is_expected.to have_link 'About',      href: about_path
    end

    it 'Contact のリンク先は /contact' do
      is_expected.to have_link 'Contact',    href: contact_path
    end

    it 'News のリンク先は, 公式のニュースサイト' do
      is_expected.to have_link 'News',       href: 'https://news.railstutorial.org/'
    end
  end
end
