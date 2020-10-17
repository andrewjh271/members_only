# Members Only

Created as part of the Odin Project curriculum.

For full functionality sign up or login with *odin@example.com* and *password*.

### Functionality

Logged in users can create, edit or delete their own posts and like or unlike posts. Posts' authors are hidden from unauthenticated viewers. An integration test for the functionality around posts uses `rspec-rails`, `capybara`, `factory_bot_rails`, and `faker`.

### Thoughts

This was my first time experimenting with scaffolding for `Post`. It was interesting to see the presumed 'best practices' in the `PostsController`. The views were initially helpful, and I mostly kept them as is except for the main `posts#index` page, which I changed completely. (But I kept the original that I first worked off of in `index0.html.erb`)

My `posts#index` page initially initiated a number of `n+1` queries, which I fixed by using `includes` as well as creating a `through` association between `users` and `posts` through the `likes` table. When determining whether to display `Like` or `Unlike` to the user while iterating through each post, I was unsure which approach was preferable, or if there's another option I hadn't considered:

```ruby
@posts.includes(:likes).each do
# ...
like = post.likes.find { |like| like.user_id == current_user.id }
# ...
# or...
like = Like.find_by(user: current_user, post: post)
```

In the first case, Ruby is not able to make use of the database index on `user_id` in the `likes` table, and is likely slower than Postgresql regardless. But in the second case there is an `n+1` query.

I expected to have trouble testing deleting a post with capybara, since there is a dialog confirmation popup. I tried

```ruby
accept_confirm do
	click_on 'Delete'
end
```

but this is not possible with the default `:rack_test` driver. I followed the instructions [here](https://github.com/teamcapybara/capybara/blob/master/README.md#drivers) to temporarily switch drivers using `Capybara.current_driver = :selenium_chrome_headless` but it never successfully opened the page. (I always got a 404 error.) I also followed the instructions [here](https://github.com/SeleniumHQ/selenium/wiki/ChromeDriver) to download the `chromedriver` executable, but that didn't help. I eventually gave up since I didn't really need to test it anyway, but I discovered testing it normally as though the dialog window didn't exist worked fine. I don't understand why it would be able to work without confirming the deletion.

The styling on the Like/Unlike buttons would have been much easier if they were links, but I couldn't figure out how to pass the same parameters into `link_to` as I have here:

```ruby
button_to 'Like', likes_path, params: { like: { user_id: current_user, post_id: post } }, class: 'like-link'
```

(The params were the difficult part.) I ended up targeting these buttons with `input[type="submit" i]` in the `posts.scss` file.

-Andrew Hayhurst