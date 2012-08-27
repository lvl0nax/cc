require 'spec_helper'

describe "months/new" do
  before(:each) do
    assign(:month, stub_model(Month,
      :name => "MyString",
      :number => 1
    ).as_new_record)
  end

  it "renders new month form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => months_path, :method => "post" do
      assert_select "input#month_name", :name => "month[name]"
      assert_select "input#month_number", :name => "month[number]"
    end
  end
end
