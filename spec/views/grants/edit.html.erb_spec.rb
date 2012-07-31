require 'spec_helper'

describe "grants/edit" do
  before(:each) do
    @grant = assign(:grant, stub_model(Grant))
  end

  it "renders the edit grant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => grants_path(@grant), :method => "post" do
    end
  end
end
