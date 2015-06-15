## Stravalog

### Background

I started writing detailed descriptions for some of my strava rides in the
description fields, for rides that were of note or races that I had been
involved in. I've found that it's hard to find activities with descriptions and
they do not even appear at all on the mobile app.

Stravalog takes these descriptions, along with other data from the API to form a blog

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


### Getting started

You can manually add activities through the admin dashboard. Or you can run
`rake strava:import` to automatically import any strava activities with a
reasonably long description


### TODO

  - Add some styling
  - Add the ability to attach photos to activities (Stravas API currently returns photo info, could use this)
  - Display more stats about rides
  - Create graphs/charts of useful information on the ride
  - Display map information
  - For lapped rides show info about lap times (This could be segment based rather than using the strava lap feature)

