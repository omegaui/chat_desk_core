import 'dart:convert';
import 'dart:io';

import 'package:chat_desk_core/core/io/logger.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Client {
  String id;
  String description;
  String code;
  String avatar;
  late WebSocketChannel channel;

  Client(
      {required this.id,
      required this.description,
      required this.code,
      required this.avatar});

  void connect(String host, int port, Function(dynamic) listener) {
    channel = WebSocketChannel.connect(
        Uri.parse("ws://$host:$port/connect/${toString()}"));
    channel.stream.listen(listener);
  }

  void transmit(String receiver, dynamic message, String id, {type = "text"}) {
    channel.sink.add(createMessage(receiver, message, type, id));
  }

  void request(dynamic data) {
    channel.sink.add(data);
  }

  void notifyChange(dynamic data) {
    channel.sink.add(data);
  }

  void notifyCompanionSwitch(String companionID) {
    notifyChange(jsonEncode({
      "type": "client-side-change",
      "code": chatSwitched,
      "with-id": companionID
    }));
  }

  @override
  String toString() {
    return jsonEncode(
        {"id": id, "description": description, "avatar": avatar, "code": code});
  }

  bool authenticate(String code) {
    return this.code == code;
  }

  static Client fromParameter(String clientData) {
    dynamic data = jsonDecode(Uri.decodeFull(clientData));
    return fromJson(data);
  }

  static Client fromJson(dynamic data) {
    return Client(
      id: data["id"],
      description: data["description"],
      code: data["code"],
      avatar: data["avatar"],
    );
  }
}

void main() {
  // Client(
  //         id: "corpus",
  //         description: "Just Another User",
  //         code: "code",
  //         avatar: base64UrlEncode(
  //             File("/home/omegaui/Downloads/icons8-package-94.png")
  //                 .readAsBytesSync()))
  //     .connect("127.0.0.1", 8080, (p0) {});
  // Client(
  //         id: "zeno",
  //         description: "Just Another User",
  //         code: "code",
  //         avatar: base64UrlEncode(
  //             File("/home/omegaui/Downloads/icons8-kawaii-shellfish-96.png")
  //                 .readAsBytesSync()))
  //     .connect("127.0.0.1", 8080, (p0) {});
  // Client(
  //         id: "_mike",
  //         description: "Just Another User",
  //         code: "code",
  //         avatar: base64UrlEncode(
  //             File("/home/omegaui/Downloads/icons8-markdown-100.png")
  //                 .readAsBytesSync()))
  //     .connect("127.0.0.1", 8080, (p0) {});
  // Client(
  //         id: "pluto",
  //         description: "Just Another User",
  //         code: "code",
  //         avatar: base64UrlEncode(
  //             File("/home/omegaui/Downloads/icons8-kawaii-shellfish-96.png")
  //                 .readAsBytesSync()))
  //     .connect("127.0.0.1", 8080, (p0) {});
  //
  var c2 = Client(
      id: "john",
      description: "Just Another User",
      code: "code",
      avatar: base64UrlEncode(
          File("/home/omegaui/Downloads/icons8-kawaii-shellfish-96.png")
              .readAsBytesSync()))
    ..connect("127.0.0.1", 8080, (p0) {});

  var client = Client(
      id: "blaze",
      description: "Just Another User",
      code: "code",
      avatar: base64UrlEncode(
          File("/home/omegaui/Downloads/icons8-linux-96.png")
              .readAsBytesSync()))
    ..connect("127.0.0.1", 8080, (p0) {});

  Future.delayed(const Duration(seconds: 4), () async {
    client.transmit("omegaui", "hello", "x");
    client.transmit("omegaui", "What are you doing?", "y");
    // client.transmit(
    //     "omegaui",
    //     base64UrlEncode(File(
    //             "/home/omegaui/Pictures/Screenshots/Screenshot from 2023-03-06 08-06-58.png")
    //         .readAsBytesSync()),
    //
    //     type: "image");
    // client.transmit(
    //     "omegaui",
    //     base64UrlEncode(File("/home/omegaui/Downloads/icons8-linux-96.png")
    //         .readAsBytesSync()),
    //     type: "image");
    // client.transmit(
    //     "omegaui",
    //     {
    //       "path": "client.dart",
    //       "name": "client.dart",
    //       "size": 98765,
    //       "data": File(
    //               "/home/omegaui/IdeaProjects/chat_desk/lib/core/client/client.dart")
    //           .readAsStringSync()
    //     },
    //     type: "text-file");
  });

  Future.delayed(const Duration(seconds: 10), () async {
    c2.transmit("omegaui", "hello", "zx");
    c2.transmit("omegaui", "What are you doing?", "zy");
  });

  // Future.delayed(const Duration(seconds: 4), () async {
  //   client.request(jsonEncode({
  //     "type": "request",
  //     "code": fetchMessages,
  //     "with-id": "john"
  //   }));
  // });
}
