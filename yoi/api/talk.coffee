"use strict"
Yoi     = require "yoi"
User    = require "../common/models/user"
Talk    = require "../common/models/talk"
Session = require "../common/session"
C       = require "../common/constants"

module.exports = (server) ->

  server.get "/api/talk", (request, response) ->
    rest = new Yoi.Rest request, response
    Session(rest).then (error, session) ->
      rest.successful()


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
            rest.run talk.parse()
          else
            rest.badRequest()

  server.put "/api/talk", (request, response) ->
    rest = new Yoi.Rest request, response
    parameters = {}
    for key in ["knowledge", "state"]
      parameters[key] = rest.parameter key if rest.parameters key
    _updateTalk rest, parameters

  server.del "/api/talk", (request, response) ->
    rest = new Yoi.Rest request, response
    _updateTalk rest, {state: C.TALK.STATE.REJECTED}

# -- Private Methods -----------------------------------------------------------
_updateTalk = (rest, parameters) ->
  if rest.required ["id"]
    Session(rest).then (error, session) ->
      Yoi.Hope.shield([ ->
        filter =
          _id: rest.parameter "id"
          $or: [
            mentor: session._id
          ,
            novice: session._id
          ]
        Talk.search filter, limit = 1
      , (error, talk) ->
        Talk.findAndUpdate {_id: talk._id}, parameters
      ]).then (error, talk) ->
        unless error?
          rest.successful()
        else
          rest.unauthorized()
