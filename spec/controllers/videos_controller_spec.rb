require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for the authenticated user" do 
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video = Fabricate(:video)
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to include(review1, review2)
    end

    it "renders the :show template for authenticated users" do
      alice = Fabricate(:user)
      session[:user_id] = alice.id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to render_template(:show)
    end

    it "redirects to the sign in page for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    context "authenticated user" do

      before { session[:user_id] = Fabricate(:user).id }

      it "sets @results to the search results" do
        futurama = Fabricate(:video, title: "Futurama")
        post :search, search_term: 'rama'
        expect(assigns(:results)).to eq([futurama])
      end

      it "renders the :search template" do
        futurama = Fabricate(:video, title: "Futurama")
        post :search, search_term: 'rama'
        expect(response).to render_template :search
      end
    end

    context "unauthenticated users" do
      it "redirects to sign in page" do
        futurama = Fabricate(:video, title: "Futurama")
        post :search, search_term: 'rama'
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
