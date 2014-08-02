"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  session = test.users[2] #novice
  # CREATE
  tasks.push _create session, test.talks[0]
  tasks.push _create session, test.talks[1]
  tasks.push _create session, test.talks[2], code = 400
  tasks.push _create session, test.talks[3], code = 400
  tasks.push _create session, test.talks[4], code = 400
  tasks.push _create session, test.talks[5], code = 400
  # UPDATE
  test.talks[1].knowledge = "mobile"
  tasks.push _update session, test.talks[1]
  session = test.users[1] #novice
  tasks.push _update session, test.talks[0], code = 401
  # DELETE
  session = test.users[2] #novice
  tasks.push _reject session, test.talks[0]
  session = test.users[1] #novice
  tasks.push _reject session, test.talks[0], code = 401
  tasks

# Promises
_create = (session, talk, code = 200) -> ->
  promise = new Yoi.Hope.Promise()
  properties =
    mentor: test.users[talk.mentor].id
    knowledge: talk.knowledge

  if code is 200
    message = "User #{session.name} creates a talk with mentor #{properties.mentor} about #{properties.knowledge}."
  else
    message = "Imposible create a talk because mentor is unalvailable or hasn't the knowledge"
  Yoi.Test "POST", "api/talk", properties, _session(session), message, code, (response) ->
    talk.id = response.id
    promise.done null, response
  promise


_update = (session, talk, code = 200) -> ->
  properties = id: talk.id
  if code is 200
    message = "User #{session.name} can update a talk."
  else
    message = "User who no participates in a talk, can't update a talk"

  Yoi.Test "DELETE", "api/talk", properties, _session(session), message, code


_reject = (session, talk, code = 200) -> ->
  properties = id: talk.id
  if code is 200
    message = "User #{session.name} can reject a talk."
  else
    message = "User who no participates in a talk, can't reject a talk"

  Yoi.Test "DELETE", "api/talk", properties, _session(session), message, code


# -- Private methods -----------------------------------------------------------
_session = (user) ->
  if user?.token? then authorization: user.token else null
