require 'spec_helper'

describe "months/index" do
  before(:each) do
    assign(:months, [
      stub_model(Month,
        :name => "Name",
        :number => 1
      ),
      stub_model(Month,
        :name => "Name",
        :number => 1
      )
    ])
  end

  it "renders a list of months" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
