{WorkspaceView} = require 'atom'
FindLetter = require '../lib/find-letter'

describe "FindLetter", ->
  editor = null
  beforeEach ->
    atom.workspaceView = new WorkspaceView()
    waitsForPromise ->
      atom.packages.activatePackage("find-letter")
    atom.workspaceView.openSync('sample.js')
    editor = atom.workspaceView.getActiveView().getEditor()

  describe "moving forward to letter", ->
    it "moves to next 't' character", ->
      atom.workspaceView.trigger 'find-letter:go-to-next-letter'
      pos = editor.getCursorBufferPosition()
      expect(pos).toEqual [0,8]
