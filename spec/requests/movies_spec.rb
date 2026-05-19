require "rails_helper"

RSpec.describe "Movies", type: :request do
  describe "GET /movies" do
    let!(:watched_movie) { create(:movie, title: "Dune", status: :watched) }
    let!(:watching_movie) { create(:movie, title: "Heat", status: :watching) }

    it "returns a successful response" do
      get movies_path

      expect(response).to have_http_status(:ok)
    end

    it "filters by status" do
      get movies_path, params: { status: "watched" }

      expect(response.body).to include("Dune")
      expect(response.body).not_to include("Heat")
    end

    it "filters by query" do
      get movies_path, params: { query: "Hea" }

      expect(response.body).to include("Heat")
      expect(response.body).not_to include("Dune")
    end
  end

  describe "POST /movies" do
    let(:valid_params) do
      {
        movie: {
          title: "Interstellar",
          genre: "Sci-Fi",
          release_year: 2014,
          status: "want_to_watch",
          synopsis: "A team travels through a wormhole to save humanity."
        }
      }
    end

    let(:invalid_params) do
      {
        movie: {
          title: "",
          genre: "",
          release_year: nil,
          status: "want_to_watch",
          synopsis: ""
        }
      }
    end

    it "creates a movie with valid params" do
      expect do
        post movies_path, params: valid_params
      end.to change(Movie, :count).by(1)

      expect(response).to redirect_to(movie_path(Movie.last))
    end

    it "renders unprocessable content with invalid params" do
      expect do
        post movies_path, params: invalid_params
      end.not_to change(Movie, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "PATCH /movies/:id" do
    let!(:movie) { create(:movie, title: "The Matrix") }

    it "updates the movie" do
      patch movie_path(movie), params: { movie: { title: "The Matrix Reloaded" } }

      expect(response).to redirect_to(movie_path(movie))
      expect(movie.reload.title).to eq("The Matrix Reloaded")
    end
  end

  describe "PATCH /movies/:id/watched" do
    let!(:movie) { create(:movie, status: :watching) }

    it "marks the movie as watched" do
      patch watched_movie_path(movie)

      expect(response).to redirect_to(movies_path)
      expect(movie.reload).to be_watched
    end

    it "returns a turbo stream response for turbo requests" do
      patch watched_movie_path(movie), headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("turbo-stream")
      expect(movie.reload).to be_watched
    end
  end

  describe "DELETE /movies/:id" do
    let!(:movie) { create(:movie) }

    it "destroys the movie" do
      expect do
        delete movie_path(movie)
      end.to change(Movie, :count).by(-1)

      expect(response).to redirect_to(movies_path)
    end

    it "returns a turbo stream remove response for turbo requests" do
      delete movie_path(movie), headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include("action=\"remove\"")
    end
  end
end