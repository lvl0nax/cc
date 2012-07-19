require 'spec_helper'

describe "resumes/edit" do
  before(:each) do
    @resume = assign(:resume, stub_model(Resume,
      :name => "MyString",
      :description => "MyString"
    ))
  end

  it "renders the edit resume form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => resumes_path(@resume), :method => "post" do
      assert_select "input#resume_name", :name => "resume[name]"
      assert_select "input#resume_description", :name => "resume[description]"
    end
  end
end
