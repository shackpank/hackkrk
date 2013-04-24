envVar = (name) ->
  messages = 
    API_TOKEN: 'get one at http://canvas.hackkrk.com/'
  process.env[name] || throw "#{name} env var not set! #{messages[name] || ''}"

request = require('request')
Twit = require('twit')
exec = require('child_process').exec
async = require('async')

t = new Twit
  consumer_key: envVar('TW_CONSUMER_KEY')
  consumer_secret: envVar('TW_CONSUMER_SECRET')
  access_token: envVar('TW_ACCESS_TOKEN')
  access_token_secret: envVar('TW_ACCESS_TOKEN_SECRET')

request.post("http://canvas.hackkrk.com/api/new_challenge.json", {
  body: 
    api_token: envVar('API_TOKEN')
  json: true
}, (err, response, body) ->
  draw.apply(null, body.color)
)

draw = (r, g, b) ->
  fillcolor = if ((r + g + b) > (128 + 128 + 128)) then 'black' else 'white'
  
  getTweet(r, g, b, (tweet) ->
    command = [
      "convert"
      "-background \"rgb(#{r},#{g},#{b})\""
      "-fill #{fillcolor}"
      "-font Arial"
      "-size 2000x64"
      "-pointsize 24"
      "-gravity center"
      "label:\"#{tweet}\""
      "temp.gif"
    ].join(' ')
    console.log command
    iMagick = exec command, ->
      console.log arguments
  )

getTweet = (r, g, b, done) ->
  idsToTry = generateCombinations(r, g, b)
  fallback = "Sorry, couldn't find a tweet ID from this colour! (tried #{idsToTry.join(',')})"
  attempts = idsToTry.map (id) ->
    (callback) ->
      t.get 'statuses/show',
        id: id
      , (err, reply) ->
        console.log arguments
        if !err and reply
          # really not how you're meant to use async, but fuck it
          callback(tweet = "#{reply.text} - @#{reply.user.screen_name}")
        else
          callback(null)

  async.series attempts, (found) ->
    tweet = found || fallback
    done tweet

generateCombinations = (r, g, b) ->
  combis = [ r, g, b, r*2, g*2, b*2, r*3, g*3, b*3 ]
  perms = []
  combis.forEach (one) ->
    combis.forEach (two) ->
      combis.forEach (three) -> perms.push [ one, two, three ]
  perms