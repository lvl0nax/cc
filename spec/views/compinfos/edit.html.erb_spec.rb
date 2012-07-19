require 'spec_helper'

describe "compinfos/edit" do
  before(:each) do
    @compinfo = assign(:compinfo, stub_model(Compinfo,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit compinfo form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => compinfos_path(@compinfo), :method => "post" do
      assert_select "input#compinfo_name", :name => "compinfo[name]"
      assert_select "input#compinfo_description", :name => "compinfo[description]"
    end
  end
end
