"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  session = test.users[2] #novice
  tasks.push _create session, test.talks[0].mentor,  test.talks[0].knowledge
  tasks.push _create session, test.talks[1].mentor,  test.talks[1].knowledge, code = 400
  tasks.push _create session, test.talks[2].mentor,  test.talks[2].knowledge, code = 400
  tasks.push _create session, test.talks[3].mentor, test.talks[3].knowledge, code = 400
  tasks.push _create session, test.talks[4].mentor, test.talks[4].knowledge, code = 400
  tasks

# Promises
_create = (session, mentor, knowledge, code = 200) -> ->
  properties =
    mentor: test.users[mentor].id
    knowledge: knowledge

  if code is 200
    message = "User #{session.name} creates a talk with mentor #{properties.mentor} about #{properties.knowledge}."
  else
    message = "Imposible create a talk because mentor is unalvailable or hasn't the knowledge"
  Yoi.Test "POST", "api/talk", properties, _session(session), message, code

# -- Private methods -----------------------------------------------------------
_session = (user) ->
  if user?.token? then authorization: user.token else null
