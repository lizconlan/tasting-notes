# Tasting Notes

A prototype app for making tasting notes about beers while you are out at events. Can also act as a scorecard if there is a competitive elements to your tasting session

Uses MongoDB for the storage layer and the BrewDB API for the beer data

Built with ruby 1.9.2 so tests must be run with simplecov instead of rcov

## Install

Copy <code>config/brewdb.yml.example</code> to <code>config/brewdb.yml</code> and add your API key

Copy <code>config/secrets.yml.example</code> to <code>config/secrets.yml</code> and provide a random string for the session cookie secret and your MongoDB connection string

<code>bundle install</code>

## Apologetics

It was supposed to look better than this (but it does alright on an iPhone). It was supposed to have brewery and event logos. (But it does at least look tolerably like a pocketbook if you squint a bit and give it the benefit of the doubt.) It was supposed to have some whizzy AJAX-y cleverness, possibly with added local storage goodness. It was supposed to have much more comprehensive test coverage. I ran out of time and started cutting corners in order to get something up other than a README file saying "I wanted to make this but never got around to it"

It will have better data as I intend to pour some more UK data into BrewDB and set up some more realistic examples before the deadline expires

## ToDo

Would be great to add other types of drink and allow for food items

Allow sharing (on an opt-in basis) of tasting notes

Better use and storage of location data with the ability to search for events on a location basis

Should be able to unwatch/delete events

A proper date picker and much better date handling

Better layout for events to handle the scenario where there are past, present and future events (event archiving?)