require 'spec_helper'

describe SearchTerm do
  let(:search_term) { FactoryGirl.create(:search_term) }

  subject { search_term }

  it { should respond_to(:search_term) }
  it { should respond_to(:count) }
  it { should respond_to(:when) }

  it { should validate_presence_of(:search_term) }
  it { should validate_uniqueness_of(:search_term) }

  describe 'receiving an AJAX request to create a new search_term' do
    describe '.update_or_create_search_term' do
      it 'should create a new search_term row if the search_term does not exist' do
        expect{ SearchTerm.update_or_create_search_term('Berlin, Germany') }.to change(SearchTerm, :count)
        expect{ SearchTerm.update_or_create_search_term('Berlin, Germany') }.to_not change(SearchTerm, :count)
        expect( SearchTerm.find_by(search_term: 'Berlin, Germany').count ).to eq 2
        expect( SearchTerm.find_by(search_term: 'Berlin, Germany').when.length ).to eq 2
      end
    end
  end

end