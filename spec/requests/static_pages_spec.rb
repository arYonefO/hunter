require 'spec_helper'

describe "Static Pages" do
  subject { page }

  describe "home page" do
    before { visit root_path }

    it { should have_selector('h1', text: "LECHE ASADA") }
    it { should have_title("Leche Asada") }
  end
end
