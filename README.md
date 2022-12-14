# README
This is an API application. This provides API endpoints. Each endpoint require valid API token in order to return. API endpoints include:

- Create new Post
- Get Post's Comments
- Create new Comment
- Delete Comment
- Rate a User
- Get User's timeline

## Setup:

1. `bundle install`
2. `rake db:create db:migrate db:seed`

## Start server:

1. `rails s`

## Run Test:

1. `rspec`

## TODO:
- Add gem swagger to display API endpoints properly
- For the User#timeline, might need to look at creating Event table to store the events and display. The 1 thing is that won't collect 'live' Comments count of the Post.
- Might consider Github#webhook to create GithubEvent so we can avoid request to GithubApi to gather records.
- Logic to avoid multiple API calls should be apply at front end, but might need logic to prevent it on backend as well.
- With current User#timeline, the disadvantage is when GithubAPI took too long to response and couldn't return data before timeout. Consider alternative above
- Need to add logic with update multiple GithubEvent on next page.

- Probably going with Event table where it'll store the Post's ID: This probably faster than using SQL UNION on large database (untested) vs this approach would need extra query for Post's Comments count AS footer
  + Add callbacks to Post create, Comment create, User#rating.
  + Point GithubApi to Event table instead of GithubEvent table.
  + Event table columns: user_id, post_id, title, event_time_at, description(footer)
  + When load User#timeline, it'll query User#events ORDER BY event_time_at DESC (faster query)
