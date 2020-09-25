import 'package:tencent_trtccalling_plugin/trtc_calling.dart';

class SignalingInfo {
  static String signalMessageKey = "signal_message";

  String key = signalMessageKey;
  int businessId = 0;
  String inviteId;
  String groupId;
  String inviter;
  String data;
  int timeout;
  int roomId;
  int version;
  bool callEnd;
  CallType callType;
  SignalingActionType actionType;
  List<String> inviteeList = List();

  SignalingInfo from(Map map) {
    return SignalingInfo();
  }

  Map toMap() {
    return Map();
  }
}

enum SignalingActionType {
  INVITE,
  CANCEL_INVITE,
  ACCEPT_INVITE,
  REJECT_INVITE,
  INVITE_TIMEOUT,
}

extension SignalingActionTypeExtension on SignalingActionType {
  int get value {
    switch (this) {
      case SignalingActionType.INVITE:
        return 1;
      case SignalingActionType.CANCEL_INVITE:
        return 2;
      case SignalingActionType.ACCEPT_INVITE:
        return 3;
      case SignalingActionType.REJECT_INVITE:
        return 4;
      case SignalingActionType.INVITE_TIMEOUT:
        return 5;
      default:
        return null;
    }
  }

  SignalingActionType from(int value) {
    switch (value) {
      case 1:
        return SignalingActionType.INVITE;
      case 2:
        return SignalingActionType.CANCEL_INVITE;
      case 3:
        return SignalingActionType.ACCEPT_INVITE;
      case 4:
        return SignalingActionType.REJECT_INVITE;
      case 5:
        return SignalingActionType.INVITE_TIMEOUT;
      default:
        return null;
    }
  }
}
