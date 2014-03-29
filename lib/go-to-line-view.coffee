{$, EditorView, Point, View} = require 'atom'

module.exports =
class GoToLineView extends View
  @activate: -> new GoToLineView

  @content: ->
    @div class: 'go-to-line overlay from-top mini', =>
      @subview 'miniEditor', new EditorView(mini: true)
      @div class: 'message', outlet: 'message'

  detaching: false

  initialize: ->
    atom.workspaceView.command 'go-to-line:toggle', '.editor', => @toggle()
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

    cursor = atom.workspaceView.getActiveView().editor.getCursor()
    currentRow = cursor.getBufferRow()
    currentLine = cursor.getCurrentBufferLine()
    
    currentCursorColumn = cursor.getBufferPosition().column
    nextOccuranceOf = currentLine.indexOf(character, currentCursorColumn + 1)
    
    cursor.setBufferPosition([currentRow, nextOccuranceOf])

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
