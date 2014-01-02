require 'spec_helper'

describe Entry do
  let(:entry) { FactoryGirl.create(:entry) }

  subject { entry }

  it { should respond_to(:url) }
  it { should respond_to(:likes) }
  it { should respond_to(:thumbnail_url) }
  it { should respond_to(:full_image_url) }
  it { should respond_to(:tags) }
  it { should respond_to(:lng) }
  it { should respond_to(:lat) }
  it { should respond_to(:prox) }
  it { should respond_to(:location) }

  it { should be_valid}

  it { should validate_uniqueness_of(:url) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:lng) }
  it { should validate_presence_of(:lat) }

  describe "When the longitude and latitude is zero" do
    before do
      entry.lng = 0
      entry.lat = 0
    end

    it { should_not be_valid }
  end

  describe "location" do
    it "should return the correct format of coordinates" do
      this_entry = Entry.new(lng: 34.4454, lat: 53.2352)
      expect(this_entry.location).to eq [this_entry.lat, this_entry.lng]
    end
  end
end