"use strict"

Yoi       = require "yoi"
Schema    = Yoi.Mongoose.Schema
db        = Yoi.Mongo.connections.primary
C         = require "../constants"

User = new Schema
  role              : type: Number, default: C.USER.ROLE.NOVICE
  available         : type: Boolean, default: C.USER.AVAILABLE
  biography         : type: String
  knowledge         : type: Object # language: level (0-none, 1-beginer, 2-medium, 3-expert)
  networks          : type: Object # network: username
  language          : type: String, default: "ES"
  appnima           :
    id              : type: String
    mail            : type: String
    username        : type: String
    name            : type: String
    avatar          : type: String
    access_token    : type: String
    refresh_token   : type: String
    password        : type: String
    expire          : type: Date
    user_agent      : type: String
    phone           : type: String
  updated_at        : type: Date
  created_at        : type: Date, default: Date.now

# -- Static methods ------------------------------------------------------------
User.statics.signup = (appnima) ->
  promise = new Yoi.Hope.Promise()
  @findOne(appnima: appnima.mail).exec (error, value) ->
    return promise.done true if value?
    properties = appnima: appnima
    user = db.model "User", User
    new user(properties).save (error, value) -> promise.done error, value
  promise

User.statics.login = (appnima) ->
  promise = new Yoi.Hope.Promise()
  filter  = "appnima.id": appnima.id
  properties = appnima: appnima
  options = upsert: true
  @findOneAndUpdate filter, properties, options, (error, value) ->
    error = code: 404, message: "User not found." if not value?
    promise.done error, value
  promise

User.statics.search = (query, limit = 0, page = 1, sort = created_at: "desc") ->
  promise = new Yoi.Hope.Promise()
  range =  if page > 1 then limit * (page - 1) else 0
  @find(query).skip(range).limit(limit).sort(sort).exec (error, value) ->
    if limit is 1
      error = code: 402, message: "User not found." if value.length is 0
      value = value[0] if value.length isnt 0
    promise.done error, value
  promise

User.statics.findAndUpdate = (filter, parameters) ->
  promise = new Yoi.Hope.Promise()
  parameters.updated_at = new Date()
  @findOneAndUpdate filter, parameters, (error, value) ->
    promise.done error, value
  promise

# -- Instance methods ----------------------------------------------------------
User.methods.parse = ->
  id        : @_id.toString()
  role      : @role
  available : @available
  biography : @biography
  networks  : @networks
  knowledge : @knowledge
  language  : @language
  mail      : @appnima.mail
  username  : @appnima.username
  name      : @appnima.name
  avatar    : @appnima.avatar
  phone     : @appnima.phone
  token     : @appnima.access_token
  appnima   : @appnima.id
  expire    : @appnima.expire
  created_at: @created_at

exports = module.exports = db.model "User", User
