import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/message_node/message_node.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling.dart';
import 'package:tencent_trtccalling_plugin/utils/string_utils.dart';

/// 自定义消息的bean实体，用来与json的相互转化
class CallModel {
  static final int VALUE_PROTOCOL_VERSION = 1;

  static String SIGNALING_EXTRA_KEY_CALL_TYPE = "call_type";
  static String SIGNALING_EXTRA_KEY_ROOM_ID = "room_id";
  static String SIGNALING_EXTRA_KEY_LINE_BUSY = "line_busy";
  static String SIGNALING_EXTRA_KEY_CALL_END = "call_end";
  static String SIGNALING_EXTRA_KEY_VERSION = "version";

  int version = 0;

  /// 表示一次通话的唯一ID
  String callId;

  /// TRTC的房间号
  int roomId = 0;

  /// IM的群组id，在群组内发起通话时使用
  String groupId = "";

  /// 信令动作
  CallActionType action = CallActionType.UNKNOWN;

  /// 通话类型
  /// 0-未知
  /// 1-语音通话
  /// 2-视频通话
  CallType callType = CallType.UNKNOWN;

  /// 正在邀请的列表
  List<String> invitedList;

  int duration = 0;

  int code = 0;

  int timestamp;
  String sender;

  // 超时时间，单位秒
  int timeout;
  String data;

  bool get isGroup => StringUtils.isNotEmpty(groupId);

  static CallModel convert2VideoCallData(MessageNode messageNode) {
    if (messageNode.nodeType != MessageNodeType.Custom) {
      return null;
    }
    CustomMessageNode node = messageNode;

    return null;
  }

  CallModel clone() {
    return this;
  }
}

enum CallActionType {
  /// 系统错误
  ERROR,

  /// 未知信令
  UNKNOWN,

  /// 正在呼叫
  DIALING,

  /// 发起人取消
  SPONSOR_CANCEL,

  /// 拒接电话
  REJECT,

  /// 无人接听
  SPONSOR_TIMEOUT,

  /// 挂断
  HANGUP,

  /// 电话占线
  LINE_BUSY,

  /// 接听电话
  ACCEPT,
}
