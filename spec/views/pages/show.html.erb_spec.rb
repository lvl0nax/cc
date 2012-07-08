require 'spec_helper'

describe "pages/show" do
  before(:each) do
    @page = assign(:page, stub_model(Page,
      :title => "Title",
      :content => "MyText",
      :meta_title => "Meta Title",
      :meta_keyword => "Meta Keyword",
      :meta_description => "Meta Description",
      :page_id => "Page"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/Meta Title/)
    rendered.should match(/Meta Keyword/)
    rendered.should match(/Meta Description/)
    rendered.should match(/Page/)
  end
end
