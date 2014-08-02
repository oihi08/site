"use strict"

Yoi       = require "yoi"
Schema    = Yoi.Mongoose.Schema
db        = Yoi.Mongo.connections.primary
C         = require "../constants"


Talk = new Schema
  mentor      : type: Schema.ObjectId, ref: "User", required: true
  novice      : type: Schema.ObjectId, ref: "User", required: true
  knowledge   : type: String, required: true
  state       : type: Number, default: C.TALK.STATE.PENDING
  duration    : type: Number, default: 0
  updated_at  : type: Date
  created_at  : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
Talk.statics.register = (properties) ->
  promise = new Yoi.Hope.Promise()
  talk = db.model "Talk", Talk
  new talk(properties).save (error, value) -> promise.done error, value
  promise

Talk.statics.findAndUpdate = (filter, parameters) ->
  promise = new Yoi.Hope.Promise()
  parameters.updated_at = new Date()
  @findOneAndUpdate filter, parameters, (error, value) ->
    promise.done error, value
  promise

Talk.statics.search = (query, limit = 0, page = 1, sort = created_at: "desc") ->
  promise = new Yoi.Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).sort(sort).exec (error, value) ->
    if limit is 1
      error = code: 402, message: "Talk not found." if value.length is 0
      value = value[0] if value.length isnt 0
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
Talk.methods.parse = ->
  id        : @_id.toString()
  mentor    : @mentor
  novice    : @novice
  knowledge : @knowledge
  state     : @state
  duration  : @duration
  updated_at: @updated_at
  created_at: @created_at

exports = module.exports = db.model "Talk", Talk
