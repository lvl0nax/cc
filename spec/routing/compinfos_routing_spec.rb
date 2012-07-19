require "spec_helper"

describe CompinfosController do
  describe "routing" do

    it "routes to #index" do
      get("/compinfos").should route_to("compinfos#index")
    end

    it "routes to #new" do
      get("/compinfos/new").should route_to("compinfos#new")
    end

    it "routes to #show" do
      get("/compinfos/1").should route_to("compinfos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/compinfos/1/edit").should route_to("compinfos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/compinfos").should route_to("compinfos#create")
    end

    it "routes to #update" do
      put("/compinfos/1").should route_to("compinfos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/compinfos/1").should route_to("compinfos#destroy", :id => "1")
    end

  end
end
