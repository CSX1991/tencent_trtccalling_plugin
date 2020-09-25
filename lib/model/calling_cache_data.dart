import 'package:tencent_trtccalling_plugin/model/call_model.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling.dart';
import 'package:tencent_trtccalling_plugin/utils/string_utils.dart';

class CallingCacheData {
  bool isInRoom = false;
  bool isOnCalling = false;
  int enterRoomTime = 0;
  CallModel lastCallModel;

  int currentRoomId = 0;
  String currentGroupId;
  String currentCallerId;
  String currentSponsorForMe;
  CallType currentCallType;
  List<String> currentInvitedList;
  Set<String> currentRoomRemoteUserSet;

  bool currentIsUseFrontCamera;
  String currentLoginUserId;

  void updateFromModel(CallModel model) {}

  void reset() {
    isOnCalling = false;
    isInRoom = false;
    enterRoomTime = 0;
    currentCallerId = "";
    currentRoomId = 0;
    currentGroupId = "";
    currentSponsorForMe = "";
    lastCallModel = CallModel();
    currentInvitedList.clear();
    currentRoomRemoteUserSet.clear();
    currentCallType = CallType.UNKNOWN;
    lastCallModel.version = CallModel.VALUE_PROTOCOL_VERSION;
  }

  bool get isGroup => StringUtils.isNotEmpty(currentGroupId);

  void startCall() {
    isOnCalling = true;
  }
}
