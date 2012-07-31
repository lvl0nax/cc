require 'spec_helper'

describe "grants/new" do
  before(:each) do
    assign(:grant, stub_model(Grant).as_new_record)
  end

  it "renders new grant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => grants_path, :method => "post" do
    end
  end
end
