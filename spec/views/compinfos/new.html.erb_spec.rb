require 'spec_helper'

describe "compinfos/new" do
  before(:each) do
    assign(:compinfo, stub_model(Compinfo,
      :name => "MyString",
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new compinfo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => compinfos_path, :method => "post" do
      assert_select "input#compinfo_name", :name => "compinfo[name]"
      assert_select "input#compinfo_description", :name => "compinfo[description]"
    end
  end
end
