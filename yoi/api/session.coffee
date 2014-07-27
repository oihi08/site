"use strict"
Yoi   = require "yoi"
User  = require "../common/models/user"

module.exports = (server) ->

  server.post "/api/login", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ['mail', 'password']
      agent       = request.headers['user-agent']
      mail        = rest.parameter "mail"
      password    = rest.parameter "password"

      Yoi.Hope.shield([->
        Yoi.Appnima.login agent, mail, password
      , (error, appnima) ->
        User.login appnima
      ]).then (error, user) ->
        return rest.exception(error.code, error.message) if error
        rest.run user.parse()


  server.post "/api/signup", (request, response) ->
    rest = new Yoi.Rest request, response
    if rest.required ['mail', 'password']
      agent       = request.headers["user-agent"]
      mail        = rest.parameter "mail"
      password    = rest.parameter "password"

      Yoi.Hope.shield([->
        Yoi.Appnima.signup agent, mail, password
      , (error, appnima) ->
        User.signup appnima
      ]).then (error, user) ->
        return rest.exception(error.code, error.message) if error
        rest.run user.parse()
