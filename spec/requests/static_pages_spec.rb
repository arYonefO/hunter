require 'spec_helper'

describe "Static Pages" do
  subject { page }

  describe "home page" do
    before { visit root_path }

    it { should have_selector('h1', text: "Leche Asada") }
    it { should have_title("Leche Asada") }
    # it "should have the content 'Leche Asada'" do
    #   visit root_path
    #   expect(page).to have_content('Leche Asada')
    #   expect(page).to have_title('Leche Asada')
    # end
  end
end
