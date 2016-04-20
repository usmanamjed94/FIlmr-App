# Filmr-App
Filmr iOS Application

This project corresponds to the Filmr Movie Recommendation engine based on a sentence the user enters. The sentence can reflect anything from a user's mode
to what he actually wants to see the movie. 

The backend is a NodeJS server. Initially we built our database by quering various open source movie details api's such as TMDB. Then we parsed
the contents of each films and stored impressions of various keywords in a film. The server has REST api's to communicate with the iOS app.
The app sends over the sentence and the server then parses it; and communicates the movies which most closely resemble the sentence entered.

The server was hosted on AWS.
