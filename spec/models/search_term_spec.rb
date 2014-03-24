require 'spec_helper'

describe SearchTerm do
  let(:search_term) { FactoryGirl.create(:search_term) }

  subject { search_term }

  it { should respond_to(:search_term) }
  it { should respond_to(:count) }
  it { should respond_to(:when) }

  it { should validate_presence_of(:search_term) }
  it { should validate_uniqueness_of(:search_term) }

end