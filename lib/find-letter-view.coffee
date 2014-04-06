{$, EditorView, Point, View} = require 'atom'

module.exports =
class FindLetterView extends View
  @activate: -> new FindLetterView

  @content: ->
    @div class: 'find-letter overlay from-top mini', =>
      @subview 'miniEditor', new EditorView(mini: true)
      @div class: 'message', outlet: 'message'

  detaching: false

  initialize: ->
    atom.workspaceView.command 'find-letter:toggle', '.editor', => @toggle()
    @miniEditor.hiddenInput.on 'focusout', => @detach() unless @detaching
    @on 'core:confirm', => @confirm()
    @on 'core:cancel', => @detach()

    @miniEditor.preempt 'textInput', (e) =>
      #false unless e.originalEvent.data.match(/[0-9]/) TODO:

  toggle: ->
    if @hasParent()
      @detach()
    else
      @attach()

  detach: ->
    return unless @hasParent()

    @detaching = true
    miniEditorFocused = @miniEditor.isFocused
    @miniEditor.setText('')

    super

    @restoreFocus() if miniEditorFocused
    @detaching = false

  confirm: ->
    character = @miniEditor.getText()

    @detach()

    editor = atom.workspaceView.getActiveView().editor
    cursor = atom.workspaceView.getActiveView().editor.getCursor()
    currentRow = cursor.getBufferRow()
    currentLine = cursor.getCurrentBufferLine()
    
    currentCursorColumn = cursor.getBufferPosition().column
    nextOccuranceOf = currentLine.indexOf(character, currentCursorColumn + 1)
    
    if editor.getSelectedText().length == 0
      cursor.setBufferPosition([currentRow, nextOccuranceOf])
    else
      start = editor.getSelectedBufferRange().start
      editor.setSelectedBufferRange([start,[currentRow, nextOccuranceOf]])

  storeFocusedElement: ->
    @previouslyFocusedElement = $(':focus')

  restoreFocus: ->
    if @previouslyFocusedElement?.isOnDom()
      @previouslyFocusedElement.focus()
    else
      atom.workspaceView.focus()

  attach: ->
    if editor = atom.workspace.getActiveEditor()
      @storeFocusedElement()
      atom.workspaceView.append(this)
      @message.text("Enter character to jump to")
      @miniEditor.focus()
