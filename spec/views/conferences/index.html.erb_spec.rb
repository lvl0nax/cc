require 'spec_helper'

describe "conferences/index" do
  before(:each) do
    assign(:conferences, [
      stub_model(Conference),
      stub_model(Conference)
    ])
  end

  it "renders a list of conferences" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
