"use strict"

Yoi = require "yoi"

module.exports = ->
  tasks = []
  session = test.users[0]
  tasks.push _info session, test.users[1]
  tasks.push _infoUnknown session, id: 0
  tasks.push _searchMentor session,
    # name: "m1"
    available: true
    knowledge: "css3"
    # language: "ES"
  tasks.push _searchMentor session,
    available: false
    knowledge: "ruby"

  tasks.push _unalvailableMentor session,
    available: true
    knowledge: "coffeescript"
  tasks


# Promises
_info = (session, profile) -> ->
  Yoi.Test "GET", "api/user", profile, _session(session), "User #{session.name} getting info from #{profile.id}.", 200

_infoUnknown = (session, profile) -> ->
  Yoi.Test "GET", "api/user", profile, _session(session), "Profile #{profile.id} doesn't exists.", 404

_searchMentor = (session, filter) -> ->
  Yoi.Test "GET", "api/mentor/search", filter: JSON.stringify(filter), _session(session), "Search mentors with a filter.", 200

_unalvailableMentor = (session, filter) -> ->
  Yoi.Test "GET", "api/mentor/search", filter: JSON.stringify(filter), _session(session), "Search mentors with a filter.", 404


# -- Private methods -----------------------------------------------------------
_session = (user) ->
  if user?.token? then authorization: user.token else null
