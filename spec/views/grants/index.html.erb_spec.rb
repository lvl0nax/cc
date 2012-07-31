require 'spec_helper'

describe "grants/index" do
  before(:each) do
    assign(:grants, [
      stub_model(Grant),
      stub_model(Grant)
    ])
  end

  it "renders a list of grants" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
