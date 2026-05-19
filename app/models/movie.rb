class Movie < ApplicationRecord
    # enum :genre, [ "Action", "Comedy", "Drama", "Horror", "Romance", "Sci_fi", "Thriller" ]
    enum :status, {
        want_to_watch: 0,
        watching: 1,
        watched: 2
    }

    validates :title, presence: true
    validates :genre, presence: true
    validates :release_year, presence: true, numericality: { only_integer: true }

    scope :watched, -> { where(status: :watched) }
    scope :watchlist, -> { where(status: [:want_to_watch, :watching]) }
    scope :top_rated, -> { order(rating: :desc) }
    # Ex:- scope :active, -> {where(:active => true)}
    scope :search, ->(query) {
        where("title ILIKE ?", "%#{query}%")
    }

    scope :with_status, ->(status) {
        where(status: status)
    }
end
