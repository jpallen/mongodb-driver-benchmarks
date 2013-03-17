mongoose = require "mongoose"
mongojs = require "mongojs"
async = require "async"
fs = require "fs"

argv = require("optimist")
	.options("mongoose", boolean: true, default: false)
	.options("mongojs", boolean: true, default: false)
	.options("pool-size", default: 1)
	.options("queries", default: 500)
	.options("db", default: "mongodb://127.0.0.1/benchmark")
	.options("spread", default: 10000)
	.options("content-size", default: 10)
	.argv


driver = "mongoose"
driver = "mongojs" if argv.mongojs

connection = mongoose.createConnection argv.db, server: poolSize: argv["pool-size"]
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

ContentSchema = new Schema
	content: type: String

DocumentSchema = new Schema
	content: [ContentSchema]

Document = connection.model "Document", DocumentSchema

db = mongojs("#{argv.db}?poolSize=#{argv["pool-size"]}", ["documents"])

setUpTestDocument = (callback = (error, id) ->) ->
	lorem = fs.readFileSync("./lorem")
	db.documents.drop (error) ->
		content = []
		for i in [1..(argv["content-size"])]
			content.push lorem
		db.documents.insert content: content, (error, documents) -> callback(error, documents[0]._id.toString())

if driver == "mongoose"
	findDocuments = (project_id, callback) ->
		Document.find { _id: project_id }, callback
else if driver == "mongojs"
	findDocuments = (project_id, callback) ->
		db.documents.find {_id: mongojs.ObjectId(project_id)}, callback

setUpTestDocument (error, document_id) ->
	async.times argv.queries, ((i, callback) ->
		setTimeout (
			() ->
				start = new Date()
				findDocuments document_id, (error, documents) ->
					console.log new Date() - start
					callback()
		), Math.random() * argv.spread
	), () -> process.exit()
	
		

