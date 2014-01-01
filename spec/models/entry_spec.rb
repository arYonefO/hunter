require 'spec_helper'

describe Entry do
  before { @entry = Entry.new }

  it { should respond_to(:url) }
  it { should respond_to(:longitude) }
  it { should respond_to(:latitude) }
  it { should respond_to(:likes) }
  it { should respond_to(:thumbnail_url) }
  it { should respond_to(:full_image_url) }
  it { should respond_to(:tags) }

end