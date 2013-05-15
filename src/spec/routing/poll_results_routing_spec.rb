require "spec_helper"

describe PollResultsController do
  describe "routing" do

    it "routes to #index" do
      get("/poll_results").should route_to("poll_results#index")
    end

    it "routes to #new" do
      get("/poll_results/new").should route_to("poll_results#new")
    end

    it "routes to #show" do
      get("/poll_results/1").should route_to("poll_results#show", :id => "1")
    end

    it "routes to #edit" do
      get("/poll_results/1/edit").should route_to("poll_results#edit", :id => "1")
    end

    it "routes to #create" do
      post("/poll_results").should route_to("poll_results#create")
    end

    it "routes to #update" do
      put("/poll_results/1").should route_to("poll_results#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/poll_results/1").should route_to("poll_results#destroy", :id => "1")
    end

  end
end
