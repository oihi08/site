"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  tasks.push _changeProfile(user) for user in test.users
  tasks


# Promises
_changeProfile = (user) -> ->
  Yoi.Test "PUT", "api/profile", user, _session(user), "El usuario #{user.name} puede cambiar su profile", 200

# Private methods
# ==============================================================================
_session = (user) ->
  if user?.token?
    authorization: user.token
  else
    null
