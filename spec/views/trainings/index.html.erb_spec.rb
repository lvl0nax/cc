require 'spec_helper'

describe "trainings/index" do
  before(:each) do
    assign(:trainings, [
      stub_model(Training),
      stub_model(Training)
    ])
  end

  it "renders a list of trainings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
