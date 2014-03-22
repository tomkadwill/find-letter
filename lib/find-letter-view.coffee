# {View} = require 'atom'
# 
# module.exports =
# class FindLetterView extends View
#   @content: ->
#     @div class: 'find-letter overlay from-top', =>
#       @div "The FindLetter package is Alive! It's ALIVE!", class: "message"
# 
#   initialize: (serializeState) ->
#     atom.workspaceView.command "find-letter:toggle", => @toggle()
# 
#   # Returns an object that can be retrieved when package is activated
#   serialize: ->
# 
#   # Tear down any state and detach
#   destroy: ->
#     @detach()
# 
#   toggle: ->
#     console.log "FindLetterView was toggled!"
#     if @hasParent()
#       @detach()
#     else
#       atom.workspaceView.append(this)
