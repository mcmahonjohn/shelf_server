import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_server/src/endpoints.dart';
import 'package:shelf_static/shelf_static.dart';

const String defaultUrl = '127.0.0.1';
const String defaultPort = '8082';
const String webIndex = 'index.html';

void main(List<String> args) {
  var parser = new ArgParser()
    ..addOption('port', abbr: 'p', defaultsTo: defaultPort);

  var result = parser.parse(args);

  var port = int.parse(result['port'].toString(), onError: (val) {
    stdout.writeln('Could not parse port value "$val" into a number.');
    exit(1);
  });

  _handleRequests(port);
}

void _handleRequests(int port) {
  var indexHandler = createStaticHandler('build/web',
      defaultDocument: webIndex);

  var handler = const shelf.Pipeline()
//      .addMiddleware(shelf.createMiddleware(requestHandler: _endpointsHandler))//, errorHandler: _errorHandler))
      // TODO Define Logger to pass
      .addMiddleware(shelf.logRequests())
      .addHandler(indexHandler);

  io.serve(handler, defaultUrl, port).then((server) {

    // Enable content compression
    server.autoCompress = true;

    print('Serving at http://${server.address.host}:${server.port}');
  });

}

/// Handles the logic for most requests
/// Forward request to service unless to /logs
Future<shelf.Response> _endpointsHandler(shelf.Request request) async {
  print('Got request for ${request.url.path}');
  var finalResponse = new shelf.Response.internalServerError();

  for (var url in endpoints.keys) {
    var endpointExp = new RegExp(url);

    if (endpointExp.hasMatch(request.url.path)) {
      print('$url contains ${request.url.path}');
      finalResponse = new shelf.Response.ok('');
    }
  }

  return finalResponse;
}

void logger(String msg, {bool isError}) {

}