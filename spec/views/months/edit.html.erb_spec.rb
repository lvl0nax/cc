require 'spec_helper'

describe "months/edit" do
  before(:each) do
    @month = assign(:month, stub_model(Month,
      :name => "MyString",
      :number => 1
    ))
  end

  it "renders the edit month form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => months_path(@month), :method => "post" do
      assert_select "input#month_name", :name => "month[name]"
      assert_select "input#month_number", :name => "month[number]"
    end
  end
end
