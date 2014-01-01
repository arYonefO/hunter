require 'spec_helper'

describe Tag do
  let(:tag) { FactoryGirl.create(:tag) }

  subject { tag }

  it { should respond_to(:label) }
  it { should respond_to(:entries) }

end