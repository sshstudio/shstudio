import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xterm/terminal/terminal.dart';

class KeyboardListener extends StatelessWidget {
  final Widget child;
  final TextEditingController textController;
  final Terminal terminal;

  KeyboardListener({@required this.child, this.textController, @required this.terminal});

  @override
  Widget build(BuildContext context) {
    return Actions(

      actions: {
        _InsertTabIntent: _InsertTabAction(),
        _ArrowKeyIntent: _InsertArrowAction(),
        _CopyIntent: _CopyAction(),
        _PasteIntent: _PasteAction(),
      },
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.tab): _InsertTabIntent(2, textController),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): _ArrowKeyIntent(textController),
          LogicalKeySet(LogicalKeyboardKey.arrowLeft): _ArrowKeyIntent(textController),
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC): _CopyIntent(terminal),
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyV): _PasteIntent(terminal),
        },
        child: child
      ),
    );
  }
}

class _PasteIntent extends Intent {
  const _PasteIntent(this.terminal);
  final Terminal terminal;
}

class _CopyIntent extends Intent {
  const _CopyIntent(this.terminal);
  final Terminal terminal;
}

class _InsertTabIntent extends Intent {
  const _InsertTabIntent(this.numSpaces, this.textController);
  final int numSpaces;
  final TextEditingController textController;
}

class _ArrowKeyIntent extends Intent {
  const _ArrowKeyIntent(this.textController);
  final TextEditingController textController;
}

class _PasteAction extends Action {
  @override
  Object invoke(covariant _PasteIntent intent) {
    Clipboard.getData(Clipboard.kTextPlain)
        .then((ClipboardData value) {
          print(value);
          intent.terminal.paste(value.text);
        });
    return '';
  }
}

class _CopyAction extends Action {
  @override
  Object invoke(covariant _CopyIntent intent) {
    print(intent.terminal.getSelectedText());
    Clipboard.setData(ClipboardData(text: intent.terminal.getSelectedText()));
    return '';
  }
}

class _InsertArrowAction extends Action {
  @override
  Object invoke(covariant Intent intent) {
    if (intent is _InsertTabIntent) {
      final oldValue = intent.textController.value;
      final newComposing = TextRange.collapsed(oldValue.composing.start);
      final newSelection = TextSelection.collapsed(
          offset: oldValue.selection.start + intent.numSpaces);

      final newText = StringBuffer(oldValue.selection.isValid
          ? oldValue.selection.textBefore(oldValue.text)
          : oldValue.text);
      for (var i = 0; i < intent.numSpaces; i++) {
        newText.write("UP!");
      }
      newText.write(oldValue.selection.isValid
          ? oldValue.selection.textAfter(oldValue.text)
          : '');
      intent.textController.value = intent.textController.value.copyWith(
        composing: newComposing,
        text: newText.toString(),
        selection: newSelection,
      );
    }
    return '';
  }
}

class _InsertTabAction extends Action {
  @override
  Object invoke(covariant Intent intent) {
    if (intent is _InsertTabIntent) {
      final oldValue = intent.textController.value;
      final newComposing = TextRange.collapsed(oldValue.composing.start);
      final newSelection = TextSelection.collapsed(
          offset: oldValue.selection.start + intent.numSpaces);

      final newText = StringBuffer(oldValue.selection.isValid
          ? oldValue.selection.textBefore(oldValue.text)
          : oldValue.text);
      for (var i = 0; i < intent.numSpaces; i++) {
        newText.write(' ');
      }
      newText.write(oldValue.selection.isValid
          ? oldValue.selection.textAfter(oldValue.text)
          : '');
      intent.textController.value = intent.textController.value.copyWith(
        composing: newComposing,
        text: newText.toString(),
        selection: newSelection,
      );
    }
    return '';
  }
}
