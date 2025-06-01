import 'package:flutter/material.dart';
import 'package:my_messenger_app_flu/models/main_model.dart';

class CustomDialog {
  static void showBottomDialogMessageOptionsWithOwner(
    BuildContext context,
    MessageEntity message, {
    void Function(MessageEntity)? onCopyMessage,
    void Function(MessageEntity)? onEditMessage,
    void Function(MessageEntity)? onDeleteMessage,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                onCopyMessage?.call(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onEditMessage?.call(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDeleteMessage?.call(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showBottomDialogMessageOptionsWithOther(
    BuildContext context,
    MessageEntity message, {
    void Function(MessageEntity)? onCopyMessage,
    void Function(MessageEntity)? onDeleteMessage,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy'),
              onTap: () {
                Navigator.pop(context);
                onCopyMessage?.call(message);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                onDeleteMessage?.call(message);
              },
            ),
          ],
        ),
      ),
    );
  }

  static void showDialogConfirmDeleteForYou(
    BuildContext context,
    MessageEntity messageEntity,
    void Function(String messageId) onDelete,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Message"),
          content: const Text(
            "This message will be deleted for you. "
            "Other chat members will still be able to see it.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onDelete(messageEntity.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
