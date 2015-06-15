## Stravalog

### Requirements

  - Ruby 2.2
  - Postgres (You can change this in `config/database.yml`

### Installation

- [Create a strava application](https://www.strava.com/settings/api), set the callback domain to be `localhost:3000` and note down the Client ID, client secret and your access token

- Copy the `.env.sample` file to `.env` and fill in the values:
  - BLOG_TITLE: The name of your blog
  - STRAVA_ATHELETE_ID: Your athelete ID, When clicking on 'Your Profile' it's the last part of the URL
  - STRAVA_CLIENT_ID: The client id of the application you've created
  - STRAVA_CLIENT_SECRET: The client secret of the application you've created
  - STRAVA_API_TOKEN: The access token of the application you've created

- Install gems with `bundle install`
- Create and migrate the database with `rake db:create db:migrate`

- Run the app with: `rails server`
- Visit `http://localhost:3000/admin` to login
