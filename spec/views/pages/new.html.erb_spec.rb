require 'spec_helper'

describe "pages/new" do
  before(:each) do
    assign(:page, stub_model(Page,
      :title => "MyString",
      :content => "MyText",
      :meta_title => "MyString",
      :meta_keyword => "MyString",
      :meta_description => "MyString",
      :page_id => "MyString"
    ).as_new_record)
  end

  it "renders new page form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => pages_path, :method => "post" do
      assert_select "input#page_title", :name => "page[title]"
      assert_select "textarea#page_content", :name => "page[content]"
      assert_select "input#page_meta_title", :name => "page[meta_title]"
      assert_select "input#page_meta_keyword", :name => "page[meta_keyword]"
      assert_select "input#page_meta_description", :name => "page[meta_description]"
      assert_select "input#page_page_id", :name => "page[page_id]"
    end
  end
end
