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
    if rest.required ["filter"]

      Session(rest).then (error, session) ->
        _filter = JSON.parse(rest.parameter "filter")

        filter = role: (MENTOR = 1)
        # filter["appnima.name"] = new RegExp _filter.name, "i" if _filter.name?
        filter.available = _filter.available if _filter.available?
        filter.language = _filter.language if _filter.language?
        filter["knowledge.#{_filter.knowledge}"] = $exists: true if _filter.knowledge?

        console.log filter
        User.search(filter).then (error, mentors) ->
          if mentors?.length > 0
            rest.run mentors: (mentor.parse() for mentor in mentors)
          else
            rest.notFound()

  # server.get "/api/novice/search", (request, response) ->
  #   rest = new Yoi.Rest request, response
  #   if rest.required ['filter']
  #     Session(rest).then (error, session) ->
  #       User.search(filter).then (error, mentors) ->
  #         if mentors?.length > 0
  #           rest.run mentors: (mentor.parse() for mentor in mentors)
  #         else
  #           rest.notFound()

