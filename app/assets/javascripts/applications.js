Paloma.controller('Applications', {
  show: function(){
    var processEditorFields = this.processEditorFields;
    $(document).on('cocoon:after-insert', function() {
      processEditorFields();
    });
    this.processEditorFields();
  },
  processEditorFields: function() {
    $('textarea.editor').each( function( index, element ){
      $element = $(element);
      editorForElement = $element.siblings('.CodeMirror').size();
      if (editorForElement == 0) {
        var editor = CodeMirror.fromTextArea(element, {
          mode: "text/x-ruby",
          matchBrackets: true,
          indentUnit: 4,
          lineNumbers: true,
          styleActiveLine: true,
          theme: 'eclipse'
        });
      }
    });
  }
});
