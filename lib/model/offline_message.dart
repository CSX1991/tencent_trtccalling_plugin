import 'package:tencent_im_plugin/entity/session_entity.dart';

class OfflineMessage {
  static final int REDIRECT_ACTION_CHAT = 1;
  static final int REDIRECT_ACTION_CALL = 2;

  int version = 1;
  int action = REDIRECT_ACTION_CHAT;
  String sender = "";
  String nickname = "";
  String faceUrl = "";
  String content = "";

  // 发送时间戳，单位秒
  int sendTime = 0;
  SessionType chatType = SessionType.C2C;

  String toString() {
    return "OfflineMessageBean{" +
        "version=$version" +
        ", chatType='$chatType" +
        '\'' +
        ", action=$action" +
        ", sender=" +
        sender +
        ", nickname=" +
        nickname +
        ", faceUrl=" +
        faceUrl +
        ", content=" +
        content +
        ", sendTime=$sendTime" +
        '}';
  }
}
