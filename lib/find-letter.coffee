#GoToNextLetter = require './go-to-next-letter'

module.exports =
  #findLetterView: null
  
  activate: (state) ->
    atom.workspaceView.command 'find-letter:go-to-next-letter', => @testTom()
    
  testTom: ->
    cursor = atom.workspaceView.getActiveView().editor.getCursor()
    cursor.setBufferPosition([0,6])
