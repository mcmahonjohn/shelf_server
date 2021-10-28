import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_server/src/endpoints.dart';
import 'package:shelf_server/src/logger.dart';
import 'package:shelf_static/shelf_static.dart';

const String defaultUrl = '127.0.0.1';
const String _defaultPort = '8082';
const String webIndex = 'index.html';

void main(List<String> args) {
  var parser = ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: _defaultPort);

  var result = parser.parse(args);

  var port = int.tryParse(result['port'].toString()) ?? _reportBadPortInput(result['port']);

  _handleRequests(port);
}

/// Sends an error to the console and then returns the default port number.
int _reportBadPortInput(dynamic badInput) {
  stdout.writeln('Could not parse port value "$badInput" into a number.');
  return int.tryParse(_defaultPort);
}

void _handleRequests(int port) {
  var indexHandler = createStaticHandler('build/web',
      defaultDocument: webIndex,);

  var handler = const shelf.Pipeline()
//      .addMiddleware(shelf.createMiddleware(requestHandler: _endpointsHandler))//, errorHandler: _errorHandler))
      // TODO Define Logger to pass
      .addMiddleware(shelf.logRequests())
      .addHandler(indexHandler);

  io.serve(handler, defaultUrl, port).then((server) {

    // Enable content compression
    server.autoCompress = true;

    logger('Serving at http://${server.address.host}:${server.port}');
  });

}

/// Handles the logic for most requests
/// Forward request to service unless to /logs
Future<shelf.Response> _endpointsHandler(shelf.Request request) async {
  logger('Got request for ${request.url.path}');
  var finalResponse = shelf.Response.internalServerError();

  for (var url in endpoints.keys) {
    var endpointExp = RegExp(url);

    if (endpointExp.hasMatch(request.url.path)) {
      logger('$url contains ${request.url.path}');
      finalResponse = shelf.Response.ok('');
    }
  }

  return finalResponse;
}
