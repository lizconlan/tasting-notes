# Tasting Notes

A prototype app for making tasting notes about beers while you are out at events. Can also act as a scorecard if there is a competitive elements to your tasting session

Uses MongoDB for the storage layer and the BrewDB API for the beer data

## Install

Copy <code>config/brewdb.yml.example</code> to <code>config/brewdb.yml</code> and add your API key

Copy <code>config/secrets.yml.example</code> to <code>config/secrets.yml</code> and provide a random string for the session cookie secret and your MongoDB connection string

<code>bundle install</code>