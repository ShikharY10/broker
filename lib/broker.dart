library broker;

import 'dart:async';
import 'package:get_it/get_it.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}


/// Returns instance of `Broker` class that was initialized at the top.
Broker getBroker() {
  Broker broker;
  broker = GetIt.I.get<Broker>(instanceName: "broker");
  return broker;
}

/// Create a broker that a registers a subscriber and then this subscriber can
/// listen to messages from anywhere from the your flutter app.
class Broker {

  late StreamController<Protocol> streamController;
  final Map<String, StreamController<dynamic>> _subscribers = {};
  final Map<String, Stream<dynamic>> _broadCasters = {};
  
  Broker() {
    streamController = StreamController<Protocol>();
    _listen();
    GetIt.I.registerSingleton<Broker>(this, instanceName: "broker");
  }

  register(String name) {
    StreamController<dynamic> externalStream = StreamController<dynamic>();
    _subscribers[name] = externalStream;
  }

  registerBroadCaster(String name) {
    StreamController<dynamic> externalStream = StreamController<dynamic>();
    _subscribers[name] = externalStream;
    _broadCasters[name] = externalStream.stream.asBroadcastStream();
  }

  delete(String name) {
    _subscribers.remove(name);
  }

  _listen() {
    streamController.stream.listen((event) {
      StreamController? externalStream = _subscribers[event.subscriber];
      if (externalStream != null) {
        externalStream.sink.add(event);
      }
    });
  }

  StreamController<dynamic> _getSubscriber(String name) {
    StreamController<dynamic>? subscriber = _subscribers[name];
    if (subscriber == null) {
      throw Exception("listening to publisher which are not yet registered");
    }
    return subscriber;
  }

  StreamSubscription<dynamic> listen(String name, void Function(dynamic event) onData) {
    StreamController<dynamic> externalStream = _getSubscriber(name);
    return externalStream.stream.listen((event) {
      onData(event);
    });
  }

  Stream<dynamic> _getBroadCaster(String subscriber) {
    Stream<dynamic>? bStream = _broadCasters[subscriber];
    if (bStream == null) {
      throw Exception("subscriber not registered");
    }
    return bStream;
  }

  StreamSubscription<dynamic> listenBroadCast(String subscriber, void Function(dynamic event) onData) {
    Stream<dynamic> externalStream = _getBroadCaster(subscriber);
    return externalStream.listen((event) {
      onData(event);
    });
  }

  publish(String publisher, String subscriber, dynamic data) {
    Protocol serviceIdentifier = Protocol(publisher, subscriber, data);
    streamController.sink.add(serviceIdentifier);
  }
}

/// When you listen for messages as a subscriber this is the type that you get
class Protocol {
  final String publisher;
  final String subscriber;
  final dynamic data;
  Protocol(this.publisher, this.subscriber, this.data);
}