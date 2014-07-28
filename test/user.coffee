"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  session = test.users[0]
  tasks.push _info session, test.users[1]
  tasks.push _infoUnknown session, id: 0
  tasks.push _search "mentor", session,
    name      : "nº1"
    available : true
    knowledge : "css3"
  tasks.push _search "mentor", session,
    available : false
    knowledge : "ruby"
  tasks.push _search "novice", session,
    knowledge : "javascript"
  tasks.push _notFound session,
    available: true
    knowledge: "coffeescript"
  tasks


# Promises
_info = (session, profile) -> ->
  Yoi.Test "GET", "api/user", profile, _session(session), "User #{session.name} getting info from #{profile.id}.", 200

_infoUnknown = (session, profile) -> ->
  Yoi.Test "GET", "api/user", profile, _session(session), "Profile #{profile.id} doesn't exists.", 404

_search = (context, session, filter) -> ->
  Yoi.Test "GET", "api/#{context}/search", filter: JSON.stringify(filter), _session(session), "Search #{context}s with #{filter.knowledge} knowledge.", 200

_notFound = (session, filter) -> ->
  Yoi.Test "GET", "api/mentor/search", filter: JSON.stringify(filter), _session(session), "Search mentors with a filter.", 404


# -- Private methods -----------------------------------------------------------
_session = (user) ->
  if user?.token? then authorization: user.token else null
