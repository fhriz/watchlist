class Movie < ApplicationRecord
    # enum :genre, [ "Action", "Comedy", "Drama", "Horror", "Romance", "Sci_fi", "Thriller" ]
    enum :status, { planned: 0, watching: 1, completed: 2 }

    validates :title, presence: true
    validates :genre, presence: true
    validates :release_year, presence: true, numericality: { only_integer: true }
end
