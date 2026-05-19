FactoryBot.define do
  factory :movie do
    title { Faker::Movie.title }
    genre { "Drama" }
    release_year { 2024 }
    synopsis { Faker::Lorem.paragraph(sentence_count: 2) }
    status { :want_to_watch }
    rating { rand(1..5) }

    trait :watching do
      status { :watching }
    end

    trait :watched do
      status { :watched }
    end
  end
end