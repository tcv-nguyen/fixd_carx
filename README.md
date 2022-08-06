# README
This is an API application. This provides API endpoints. Each endpoint require valid API token in order to return. API endpoints include:

- Create new Post
- Get Post's Comments
- Create new Comment
- Delete Comment
- Rate a User

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
