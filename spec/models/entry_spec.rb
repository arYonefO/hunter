require 'spec_helper'

describe Entry do
  let(:entry) { FactoryGirl.create(:entry) }

  subject { entry }

  it { should respond_to(:url) }
  it { should respond_to(:likes) }
  it { should respond_to(:thumbnail_url) }
  it { should respond_to(:full_image_url) }
  it { should respond_to(:tags) }
  it { should respond_to(:longitude) }
  it { should respond_to(:latitude) }
  it { should respond_to(:prox) }
  it { should respond_to(:location) }

  it { should be_valid}

  it { should validate_uniqueness_of(:url) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:longitude) }
  it { should validate_presence_of(:latitude) }

  describe "When the longitude and latitude is zero" do
    before do
      entry.longitude = 0
      entry.latitude = 0
    end

    it { should_not be_valid }
  end

  describe "location" do
    it "should return the correct format of coordinates" do
      this_entry = Entry.new(longitude: 34.4454, latitude: 53.2352)
      expect(this_entry.location).to eq [this_entry.latitude, this_entry.longitude]
    end
  end

  describe "proximity count" do

    describe "should return zero if there are no nearby entries" do
      its(:prox) { should eq 0 }
    end

    describe "should return the correct number of nearby entries" do
      let!(:entry1) { FactoryGirl.create(:entry) }
      let!(:entry2) { FactoryGirl.create(:entry) }
      let!(:entry3) { FactoryGirl.create(:entry) }
      let!(:entry4) { FactoryGirl.create(:entry, longitude: 34.4454, latitude: 53.2352) }
      its(:prox) { should eq 3 }
    end
  end
end