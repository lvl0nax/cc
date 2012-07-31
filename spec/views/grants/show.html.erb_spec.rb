require 'spec_helper'

describe "grants/show" do
  before(:each) do
    @grant = assign(:grant, stub_model(Grant))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
