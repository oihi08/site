"use strict"
Yoi     = require "yoi"
User    = require "../common/models/user"
Talk    = require "../common/models/talk"
Session = require "../common/session"
C       = require "../common/constants"

module.exports = (server) ->

  server.post "/api/talk", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ["mentor", "knowledge"]
      Session(rest).then (error, session) ->
        Yoi.Hope.shield([ ->
          # It's a available mentor
          knowledge = rest.parameter "knowledge"
          filter =
            _id       : rest.parameter "mentor"
            role      : C.USER.ROLE.MENTOR
            available : C.USER.AVAILABLE
          filter["knowledge.#{knowledge}"] = $exists: true
          User.search filter, limit = 1
        , (error, value) ->
          Talk.register
            mentor    : rest.parameter "mentor"
            novice    : session
            knowledge : rest.parameter "knowledge"
        ]).then (error, talk) ->
          unless error?
            rest.run talk: talk.parse()
          else
            rest.badRequest()
