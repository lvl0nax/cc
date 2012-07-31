require 'spec_helper'

describe "trainings/new" do
  before(:each) do
    assign(:training, stub_model(Training).as_new_record)
  end

  it "renders new training form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => trainings_path, :method => "post" do
    end
  end
end
