require "spec_helper"

describe MonthsController do
  describe "routing" do

    it "routes to #index" do
      get("/months").should route_to("months#index")
    end

    it "routes to #new" do
      get("/months/new").should route_to("months#new")
    end

    it "routes to #show" do
      get("/months/1").should route_to("months#show", :id => "1")
    end

    it "routes to #edit" do
      get("/months/1/edit").should route_to("months#edit", :id => "1")
    end

    it "routes to #create" do
      post("/months").should route_to("months#create")
    end

    it "routes to #update" do
      put("/months/1").should route_to("months#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/months/1").should route_to("months#destroy", :id => "1")
    end

  end
end
