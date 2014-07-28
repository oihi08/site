"use strict"
Yoi     = require "yoi"
User    = require "../common/models/user"
Session = require "../common/session"

module.exports = (server) ->

  server.get "/api/user", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ['id']
      Session(rest).then (error, session) ->
        User.search(_id: rest.parameter("id")).then (error, users) ->
          if users?.length > 0
            rest.run users[0].parse()
          else
            rest.notFound()
