require 'spec_helper'

describe "compinfos/show" do
  before(:each) do
    @compinfo = assign(:compinfo, stub_model(Compinfo,
      :name => "Name",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Description/)
  end
end
