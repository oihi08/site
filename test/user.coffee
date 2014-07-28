"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  tasks.push _info test.users[0], test.users[1]
  tasks.push _infoUnknown test.users[0], id: 0
  tasks


# Promises
_info = (user, profile) -> ->
  Yoi.Test "GET", "api/user", profile, _session(user), "User #{user.name} getting info from #{profile.id}.", 200

_infoUnknown = (user, profile) -> ->
  Yoi.Test "GET", "api/user", profile, _session(user), "Profile #{profile.id} doesn't exists.", 404


# -- Private methods -----------------------------------------------------------
_session = (user) ->
  if user?.token? then authorization: user.token else null
