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



  describe '.ingest' do
    API_RESPONSE =
    [
      {
        location: { latitude: 34.34555, longitude: 42.42555 },
        likes: { count: 7 },
        link: 'www.instawoop.com/978adfg9hadg9/',
        created_time: "2014-01-02 11:03:17",
        images: { standard_resolution: {url: 'www.instawoop.com/978adfg9hadsag9/'}, thumbnail: {url: 'www.instawoop.com/978adfg9hadsag9/'} },
        tags: ['floops', 'cotton', 'memos']
      },
      {
        location: { latitude: 34.34555, longitude: 42.42555 },
        likes: { count: 7 },
        link: 'www.instawoop.com/978adadsfgadfg9hadg9/',
        created_time: "2014-01-02 11:03:17",
        images: { standard_resolution: {url: 'www.instawoop.com/978adfg9hadsag9/'}, thumbnail: {url: 'www.instawoop.com/978adfg9hadsag9/'} },
        tags: ['floops', 'cotton', 'memos']
      },
      {
        location: nil,
        likes: { count: 7 },
        link: 'www.instawoop.com/978aadghhedfg9hadg9/',
        created_time: "2014-01-02 11:03:17",
        images: { standard_resolution: {url: 'www.instawoop.com/978adfg9hadsag9/'}, thumbnail: {url: 'www.instawoop.com/978adfg9hadsag9/'} },
        tags: ['flps', 'cttn', 'mms']
      },
      {
        location: { latitude: 0, longitude: 0 },
        likes: { count: 7 },
        link: 'www.instawoop.com/978adfg9haasdfdg9/',
        created_time: "2014-01-02 11:03:17",
        images: { standard_resolution: {url: 'www.instawoop.com/978adfg9hadsag9/'}, thumbnail: {url: 'www.instawoop.com/978adfg9hadsag9/'} },
        tags: ['flps', 'cttn', 'mms']
      }
    ]
    before :all do
      Entry.ingest(API_RESPONSE)
      @legit_entry = 'www.instawoop.com/978adfg9hadg9/'
      @false_entry1 = 'www.instawoop.com/978aadghhedfg9hadg9/'
      @false_entry2 = 'www.instawoop.com/978adfg9haasdfdg9/'
      @legit_entry2 = 'www.instawoop.com/978adadsfgadfg9hadg9/'
      @association_check = Entry.find_by url: @legit_entry2
    end

    it 'should have put the first entry in the database' do
      expect(Entry.find_by url: @legit_entry).to be_true
    end

    it 'should not have put the second entry in the database' do
      expect(Entry.find_by url: @false_entry1).to_not be_true
    end

    it 'should not have put the third entry in the database' do
      expect(Entry.find_by url: @false_entry2).to_not be_true
    end

    it 'should generate appropriate relationships for preexisting tags' do
      expect(@association_check.tags.count).to eq 3
    end
  end
end