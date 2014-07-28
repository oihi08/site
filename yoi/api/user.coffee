"use strict"
Yoi     = require "yoi"
User    = require "../common/models/user"
Session = require "../common/session"

module.exports = (server) ->

  server.get "/api/user", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ["id"]
      Session(rest).then (error, session) ->
        User.search(_id: rest.parameter("id")).then (error, users) ->
          if users?.length > 0
            rest.run users[0].parse()
          else
            rest.notFound()

  #-- Filter Methods -----------------------------------------------------------
  server.get "/api/:context/search", (request, response) ->
    rest = new Yoi.Rest request, response
    CONTEXTS = ["novice", "mentor"]
    if rest.required ["filter"]
      Session(rest).then (error, session) ->
        page = rest.parameter "page"
        values = JSON.parse(rest.parameter "filter")

        filter = role: CONTEXTS.indexOf rest.parameter "context"
        filter["appnima.name"] = new RegExp(values.name, "i") if values.name?
        filter.available = values.available if values.available?
        filter.language = values.language if values.language?
        filter["knowledge.#{values.knowledge}"] = $exists: true if values.knowledge?

        User.search(filter, limit = 32, page = 1).then (error, users) ->
          if users?.length > 0
            rest.run users: (mentor.parse() for mentor in users)
          else
            rest.notFound()
