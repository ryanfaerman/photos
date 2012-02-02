express	 = require 'express'
fs = require 'fs'
_ = require 'underscore'
#MongoStore = require('connect-mongo')

# Create the Express Server and active some middleware
app = module.exports = express.createServer()

# Configuration
app.configure ->
	app.set 'views', "#{__dirname}/views"
	app.set 'view engine', 'mustache'
	app.register '.mustache', require 'stache'
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.static "#{__dirname}/public"
	
	app.use express.cookieParser()
	#app.use express.session 
	#	secret: 'bingobongo'
	#	store: new MongoStore(db: config.db.db, host: config.db.host)
	
app.configure 'development', ->
	app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
	app.use express.errorHandler()

# The dynamic helpers give system-level variables to the views
# so each route doesn't need to mess with all that noise.
app.dynamicHelpers 
	#flash: (req, res) ->
	#  req.flash()

# Now we go ahead and get all our controllers rolling.
_.each fs.readdirSync('./controllers'), (controller) ->
	require("./controllers/#{controller}")(app)


# Finally, after everything else, start up the server.
app.listen 3000
console.log "Express server listening on port #{app.address().port} in #{app.settings.env} mode"