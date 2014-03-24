require 'spec_helper'

describe SearchTerm do
  let(:search_term) { FactoryGirl.create(:search_term) }

  subject { search_term }

  it { should respond_to(:search_term) }
  it { should respond_to(:count) }
  it { should respond_to(:when) }

  it { should validate_presence_of(:search_term) }
  it { should validate_uniqueness_of(:search_term) }

  # Currently the methods tested below are working as expected in IRB. Need to get the specs to work!
  describe 'receiving an AJAX request to create a new search_term' do
    describe '.update_or_create_search_term' do
      let!(:berlin_search_term) { 'Berlin, Germany' }
      let(:berlin_search_term2) { 'Berlin, Germany' }
      let(:first_time) { SearchTerm.update_or_create_search_term(berlin_search_term) }
      let(:second_time) { SearchTerm.update_or_create_search_term(berlin_search_term2) }
      it 'should create a new search_term row if the search_term does not exist' do
        expect(first_time).to change(SearchTerm, :count)
      end

      it 'should update the existing search_term if it already exists' do
        expect(second_time).to_not change(SearchTerm, :count)
      end
    end
  end

end