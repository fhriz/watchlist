# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# create 10 movie seed with random data
10.times do |i|
    Movie.find_or_create_by!(title: "Movie Title #{i + 1}", genre: [ "Action", "Comedy", "Drama", "Horror" ].sample, rating: rand(1..5), release_year: rand(2020..2026), status: rand(0..2))
end
