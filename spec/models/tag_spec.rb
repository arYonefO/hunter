require 'spec_helper'

describe Tag do
  before { @tag = Tag.new }

  subject { @tag}

  it { should respond_to(:label) }
  it { should respond_to(:entries) }

end