import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart';

/// Create a WebSocket connection.
Future<WebSocket> connect(
  String url, {
  Iterable<String>? protocols,
  Duration? pingInterval,
  String? binaryType,
}) async {
  final socket = WebSocket(
    url,
    (protocols?.toList() ?? const <String>[]).map((e) => e.toJS).toList().toJS,
  )..binaryType = binaryType ?? 'list';

  if (socket.readyState == 1) return socket;

  final completer = Completer<WebSocket>();

  socket
    ..onopen = (_) {
      completer.complete(socket);
    }.toJS
    ..onerror = (dynamic event) {
      final error = event is ErrorEvent ? event.error : null;
      completer.completeError(error ?? 'unknown error');
    }.toJS;

  return completer.future;
}
