"use strict"

Yoi     = require "yoi"
User    = require "../common/models/user"
Session = require "../common/session"

module.exports = (server) ->

  server.put "/api/profile", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ["available"]
      Session(rest).then (error, session) ->
        agent = request.headers["user-agent"]
        parameters = {}
        for key in ["name", "available", "biography", "knowledge", "networks", "avatar"]
          parameters[key] = rest.parameter(key) if rest.parameter(key)?

        Yoi.Hope.shield([->
          Yoi.Appnima.api agent, "PUT", "user/info", rest.session, parameters
        , (error, appnima) ->
          parameters["appnima.name"] = appnima.name
          parameters["appnima.avatar"] = appnima.avatar
          User.findAndUpdate _id: session._id, parameters
        ]).then (error, user) ->
          if error?
            rest.exception error.code, error.message
          else
            rest.run user: user.parse()

  server.put "/api/profile/password", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ["old_password", "new_password"]
      Session(rest).then (error, session) ->
        agent = request.headers["user-agent"]
        old_password = rest.parameter "old_password"
        new_password = rest.parameter "new_password"
        if old_password and new_password
          parameters =
            old_password: old_password
            new_password: new_password
          token = session.appnima.access_token
          Yoi.Appnima.api(agent, "PUT", "user/password", token, parameters).then (error, response) ->
            if error?
              rest.exception error.code, error.message
            else
              rest.run user: user.parse()
