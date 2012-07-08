require 'spec_helper'

describe "pages/index" do
  before(:each) do
    assign(:pages, [
      stub_model(Page,
        :title => "Title",
        :content => "MyText",
        :meta_title => "Meta Title",
        :meta_keyword => "Meta Keyword",
        :meta_description => "Meta Description",
        :page_id => "Page"
      ),
      stub_model(Page,
        :title => "Title",
        :content => "MyText",
        :meta_title => "Meta Title",
        :meta_keyword => "Meta Keyword",
        :meta_description => "Meta Description",
        :page_id => "Page"
      )
    ])
  end

  it "renders a list of pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Meta Title".to_s, :count => 2
    assert_select "tr>td", :text => "Meta Keyword".to_s, :count => 2
    assert_select "tr>td", :text => "Meta Description".to_s, :count => 2
    assert_select "tr>td", :text => "Page".to_s, :count => 2
  end
end
