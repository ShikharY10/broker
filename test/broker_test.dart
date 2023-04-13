import 'package:flutter_test/flutter_test.dart';

import 'package:broker/broker.dart';

void main() {
  
  test("register and listen", () {
    final broker = Broker();
    broker.register("<subscriber>");

    broker.listen("<subscriber>", (event) {
      Protocol protocol = (event as Protocol);
      expect(protocol.subscriber, "<subscriber>");
      expect(protocol.publisher, "<publisher>");
      expect(protocol.data, "<message-that-you-want-to-send>");
    });

    broker.publish("<publisher>", "<subscriber>", "<message-that-you-want-to-send>");
  });
}
