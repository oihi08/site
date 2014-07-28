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
