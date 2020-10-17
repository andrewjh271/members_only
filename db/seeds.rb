# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def random_post
  @posts.pop
end

def random_post_reset!(n = 45)
  @posts = (0..n).to_a.shuffle
end

ActiveRecord::Base.transaction do
  Like.destroy_all
  Post.destroy_all
  User.destroy_all

  users = []
  15.times do |i|
    users[i] = User.create(
      username: (Faker::GreekPhilosophers.name.downcase + rand(999).to_s),
      email: Faker::Internet.email,
      password: 'mandolin'
    )
  end
  10.times do |i|
    users[i + 15] = 
    User.create(
      username: Faker::Internet.username,
      email: Faker::Internet.email,
      password: 'mandolin'
    )
  end

  posts = []
  30.times do |i|
    date = Faker::Date.between(from: 2.years.ago, to: Date.today)
    posts[i] = Post.create(
      title: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
      body: Faker::GreekPhilosophers.quote,
      author: users[rand(15)],
      created_at: date,
      updated_at: date
    )
  end
  15.times do |i|
    date = Faker::Date.between(from: 2.years.ago, to: Date.today)
    posts[i + 30] = Post.create(
      title: Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4),
      body: Faker::Lorem.paragraph(sentence_count: 6, supplemental: true, random_sentences_to_add: 50),
      author: users[rand(10) + 15],
      created_at: date,
      updated_at: date
    )
  end

  # Sample user:
  example_user = User.create(
    username: 'odin',
    email: 'odin@example.com',
    password: 'password'
  )
  # Sample post:
  example_post = Post.create(
    title: Faker::Lorem.sentence(word_count: 3, supplemental: true),
    body: Faker::GreekPhilosophers.quote,
    author: example_user
  )

  25.times do |i|
    Like.create(post: example_post, user: users[i])
    random_post_reset!
    rand(45).times do
      Like.create(post: posts[random_post], user: users[i])
    end
  end
end