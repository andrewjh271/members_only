# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  body       :text             not null
#  author_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.word.capitalize }
    body { Faker::GreekPhilosophers.quote }
    author { create(:user) }
  end
end