HackKrk
=======

A quick bit of code written at the HackKrk after railsberry. Didn't work out but I at least ended up playing a bit more with ImageMagick.

Challenge
--------

Make a request to an API, this would give you a colour as RGB values. You then had to submit an image to that same API whose average colour was close to those RGB values.

Approach
--------

I was going to use the twitter API to fetch a tweet, write it to an image with the background of that RGB value (and if time, instead fetch the user's pic and recolour it around the average colour) and submit that image as the response.

Generating the tweet's ID would be done through combining the supplied RGB values somehow.

Problem
-------

It turns out randomly generating a number that happens to be a valid tweet is more difficult than it appears. Simple attempts with low numbers of permutations would have every attempt 404, attempts with high numbers (eg through including multiples of the RGB values) would hit the rate limiter before generating a valid ID.

I can only assume the tweets you can get through the API don't go back far enough that the last nine digits being randomised will point to unavailable messages almost every time, or that tweet IDs include a check digit (- if they do it isn't using Luhn)