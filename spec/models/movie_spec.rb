require "rails_helper"

RSpec.describe Movie, type: :model do
  describe "validations" do
    subject(:movie) { build(:movie) }

    it "is valid with valid attributes" do
      expect(movie).to be_valid
    end

    it "requires a title" do
      movie.title = nil

      expect(movie).not_to be_valid
      expect(movie.errors[:title]).to include("can't be blank")
    end

    it "requires a genre" do
      movie.genre = nil

      expect(movie).not_to be_valid
      expect(movie.errors[:genre]).to include("can't be blank")
    end

    it "requires a release year" do
      movie.release_year = nil

      expect(movie).not_to be_valid
      expect(movie.errors[:release_year]).to include("can't be blank")
    end

    it "requires the release year to be an integer" do
      movie.release_year = 1999.5

      expect(movie).not_to be_valid
      expect(movie.errors[:release_year]).to include("must be an integer")
    end
  end

  describe "enums" do
    it "defines the expected statuses" do
      expect(described_class.statuses).to eq(
        "want_to_watch" => 0,
        "watching" => 1,
        "watched" => 2
      )
    end
  end

  describe "scopes" do
    let!(:wanted_movie) { create(:movie, title: "Arrival", status: :want_to_watch) }
    let!(:watching_movie) { create(:movie, title: "Alien", status: :watching) }
    let!(:watched_movie) { create(:movie, title: "Blade Runner", status: :watched) }

    describe ".watched" do
      it "returns only watched movies" do
        expect(described_class.watched).to contain_exactly(watched_movie)
      end
    end

    describe ".watchlist" do
      it "returns movies that are not yet watched" do
        expect(described_class.watchlist).to contain_exactly(wanted_movie, watching_movie)
      end
    end

    describe ".search" do
      it "matches titles by partial search" do
        expect(described_class.search("Ali")).to contain_exactly(watching_movie)
      end
    end

    describe ".with_status" do
      it "filters by status" do
        expect(described_class.with_status(:watching)).to contain_exactly(watching_movie)
      end
    end
  end
end
