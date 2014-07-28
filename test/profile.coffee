"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  tasks.push _noAuthentification name: "unknown", available: false
  tasks.push _changeProfile(user) for user in test.users
  tasks.push _changePassword(user)
  tasks


# Promises
_changeProfile = (user) -> ->
  Yoi.Test "PUT", "api/profile", user, _session(user), "User #{user.name} change his profile.", 200

_noAuthentification = (user) -> ->
  Yoi.Test "PUT", "api/profile", user, _session(user), "User #{user.name} hasn't authentification to change profile.", 401

_changePassword = (user) -> ->
  parameters =
    old_password: user.password
    new_password: user.password
  Yoi.Test "PUT", "api/profile/password", parameters, _session(user), "User #{user.name} change his password to #{}.", 200

# -- Private methods -----------------------------------------------------------
_session = (user) ->
  if user?.token? then authorization: user.token else null
