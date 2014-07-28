"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  tasks.push _signup(user) for user in test.users
  tasks.push _login(user) for user in test.users
  tasks


# Promises
_signup = (user) -> ->
  Yoi.Test "POST", "api/signup", user, null, "User #{user.name} registered with App/Nima.", 409

_login = (user) -> ->
  promise = new Yoi.Hope.Promise()
  Yoi.Test "POST", "api/login", user, null, "User #{user.name} logged with App/Nima.", 200, (response) ->
    user.id = response.id
    user.token = response.token
    promise.done null, response
  promise
