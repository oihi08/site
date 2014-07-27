"use strict"

Yoi     = require "yoi"
User    = require "./models/user"

module.exports = (rest, redirect = false) ->
  promise = new Yoi.Hope.Promise()
  token = rest.session
  if token
    User.findOne("appnima.access_token": token).exec (error, user) ->
      unless user?
        if redirect then promise.done true else do rest.unauthorized
      else
        promise.done error, user
  else
    if redirect then promise.done true else do rest.unauthorized
  promise
