require 'spec_helper'

describe "resumes/index" do
  before(:each) do
    assign(:resumes, [
      stub_model(Resume,
        :name => "Name",
        :description => "Description"
      ),
      stub_model(Resume,
        :name => "Name",
        :description => "Description"
      )
    ])
  end

  it "renders a list of resumes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
