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
        InsertTabIntent: InsertTabAction(),
        InsertUpIntent: InsertUpAction(),
        CopyIntent: CopyAction(),
        PasteIntent: PasteAction(),
      },
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.tab): InsertTabIntent(2, textController),
          LogicalKeySet(LogicalKeyboardKey.arrowUp): InsertUpIntent(textController),
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyC): CopyIntent(terminal),
          LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyV): PasteIntent(terminal),
        },
        child: child
      ),
    );
  }
}

class PasteIntent extends Intent {
  const PasteIntent(this.terminal);
  final Terminal terminal;
}

class PasteAction extends Action {
  @override
  Object invoke(covariant PasteIntent intent) {
    Clipboard.getData(Clipboard.kTextPlain)
        .then((ClipboardData value) {
          print(value);
          intent.terminal.paste(value.text);
        });
    return '';
  }
}

class CopyIntent extends Intent {
  const CopyIntent(this.terminal);
  final Terminal terminal;
}

class CopyAction extends Action {
  @override
  Object invoke(covariant CopyIntent intent) {
    print(intent.terminal.getSelectedText());
    Clipboard.setData(ClipboardData(text: intent.terminal.getSelectedText()));
    return '';
  }
}

class InsertUpIntent extends Intent {
  const InsertUpIntent(this.textController);
  final TextEditingController textController;
}

class InsertUpAction extends Action {
  @override
  Object invoke(covariant Intent intent) {

    print('UP KEY');
    if (intent is InsertTabIntent) {
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

class InsertTabIntent extends Intent {
  const InsertTabIntent(this.numSpaces, this.textController);
  final int numSpaces;
  final TextEditingController textController;
}

class InsertTabAction extends Action {
  @override
  Object invoke(covariant Intent intent) {
    if (intent is InsertTabIntent) {
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
