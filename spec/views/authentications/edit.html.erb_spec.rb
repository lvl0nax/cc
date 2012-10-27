require 'spec_helper'

describe "authentications/edit" do
  before(:each) do
    @authentication = assign(:authentication, stub_model(Authentication,
      :user_id => 1
    ))
  end

  it "renders the edit authentication form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => authentications_path(@authentication), :method => "post" do
      assert_select "input#authentication_user_id", :name => "authentication[user_id]"
    end
  end
end
