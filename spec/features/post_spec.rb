require 'rails_helper'

feature 'creating a new post' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post) }

  scenario 'has a create page' do
    sign_in(user)
    visit new_post_url
    expect(page).to have_content 'New Post'
  end

  feature 'creates a post' do
    background(:each) do
      sign_in(user)
      visit new_post_url
      fill_in 'post_title', with: 'Green fire'
      fill_in 'post_body', with: 'Green fire is lucky.'
      click_on 'Create Post'
    end

    scenario 'redirects to post show page after creation' do
      expect(page).to have_content 'Green fire'
      expect(page).to have_content 'Green fire is lucky'
    end
  end

  feature 'user who isn\'t logged in' do
    scenario 'redirects to login for unauthenticated user' do
      visit new_post_url
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end

feature 'editing an existing post' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, author: user) }

  scenario 'has an edit page' do
    sign_in(user)
    visit edit_post_url(post)
    expect(page).to have_content 'Edit Post'
  end

  scenario 'updates post and redirects to show page' do
    sign_in(user)
    visit edit_post_url(post)
    fill_in 'post_title', with: 'Green fire'
    fill_in 'post_body', with: 'Green fire is lucky.'
    click_on 'Update Post'
    expect(page).to have_content 'Green fire is lucky'
    expect(page).not_to have_content post.title
  end

  scenario 'does not allow edit for user who is not author' do
    sign_in(FactoryBot.create(:user))
    visit edit_post_url(post)
    expect(page).to have_content('You are not authorized to edit this post!')
  end
end

feature 'deleting a post' do
  given(:user) { FactoryBot.create(:user) }
  given(:post) { FactoryBot.create(:post, author: user) }
  
  scenario 'deletes post and redirects to index' do
    sign_in(user)
    visit post_url(post)
    expect(page).to have_content post.title
    expect(page).to have_content post.body
    
    click_on 'Delete'
    expect(page).not_to have_content post.title
    expect(page).not_to have_content post.body
  end
end

feature 'homepage (posts#index)' do
  given(:user1) { FactoryBot.create(:user) }
  given(:user2) { FactoryBot.create(:user) }
  given(:post1) { FactoryBot.create(:post) }
  given(:post2) { FactoryBot.create(:post) }

  scenario 'shows all the posts' do
    post1
    post2
    visit posts_url
    expect(page).to have_content post1.title
    expect(page).to have_content post1.body
    expect(page).to have_content post2.title
    expect(page).to have_content post2.body
    expect(page).to have_content 'less than a minute ago'
  end

  scenario 'does not show author for unauthenticated user' do
    post1
    visit posts_url
    expect(page).not_to have_content post1.author.username
  end

  scenario 'does show author for authenticated user' do
    post1
    sign_in(user1)
    visit posts_url
    expect(page).to have_content post1.author.username
  end

  scenario 'shows like button for unauthenticated user' do
    post1
    sign_in(user1)
    visit posts_url
    expect(page).to have_button('Like')
  end

  scenario 'does not show like button for unauthenticated user' do
    post1
    visit posts_url
    expect(page).not_to have_button('Like')
  end

  scenario 'toggles Like button' do
    post1
    sign_in(user1)
    visit posts_url
    expect(page).to have_button('Like')
    expect(page).not_to have_button('Unlike')
    click_on 'Like'
    expect(page).not_to have_button('Like')
    expect(page).to have_button('Unlike')
    click_on 'Unlike'
    expect(page).to have_button('Like')
    expect(page).not_to have_button('Unlike')
  end

  scenario 'shows count for post\'s number of likes' do
    post1
    sign_in(user1)
    visit posts_url
    expect(page).to have_content('0')
    click_on 'Like'
    expect(page).to have_content('1')
    expect(page).not_to have_content('0')

    sign_in(user2)
    visit posts_url
    click_on 'Like'
    expect(page).to have_content('2')
    expect(page).not_to have_content('1')
    click_on 'Unlike'
    expect(page).to have_content('1')
  end
end