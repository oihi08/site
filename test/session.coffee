"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  tasks.push _signup(user) for user in test.users
  tasks.push _login(user) for user in test.users
  tasks


# Promises
_signup = (user) -> ->
  Yoi.Test "POST", "api/signup", user, null, "El usuario #{user.name} se registra con App/Nima", 409

_login = (user) -> ->
  promise = new Yoi.Hope.Promise()
  Yoi.Test "POST", "api/login", user, null, "El usuario #{user.name} hace login.", 200, (response) ->
    user.id = response.id
    user.token = response.token
    promise.done null, response
  promise
