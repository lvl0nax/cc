require 'spec_helper'

describe "trainings/edit" do
  before(:each) do
    @training = assign(:training, stub_model(Training))
  end

  it "renders the edit training form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => trainings_path(@training), :method => "post" do
    end
  end
end
