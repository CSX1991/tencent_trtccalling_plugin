import 'package:flutter/src/widgets/framework.dart';
import 'package:tencent_trtccalling_plugin/model/internal_listener_manager.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling_delegate.dart';

class TRTCCallingImpl extends TRTCCalling {
  /// 超时时间，单位秒
  static final int TIME_OUT_COUNT = 30;

  /// room id 的取值范围
  static final int ROOM_ID_MIN = 1;
  static final int ROOM_ID_MAX = double.maxFinite.toInt();

  /// 底层SDK调用实例
//  TRTCCloud mTRTCCloud;

  /// 当前IM登录用户名
  String mCurUserId = "";
  int mSdkAppId;
  String mCurUserSig;

  /// 是否首次邀请
  bool isOnCalling = false;
  String mCurCallID = "";
  int mCurRoomID = 0;

  /// 当前是否在TRTC房间中
  bool mIsInRoom = false;
  int mEnterRoomTime = 0;

  /// 当前邀请列表
  /// C2C通话时会记录自己邀请的用户
  /// IM群组通话时会同步群组内邀请的用户
  /// 当用户接听、拒绝、忙线、超时会从列表中移除该用户
  List<String> mCurInvitedList = List();

  /// 当前语音通话中的远端用户
  Set<String> mCurRoomRemoteUserSet = Set();

  /// C2C通话的邀请人
  /// 例如A邀请B，B存储的mCurSponsorForMe为A
  String mCurSponsorForMe = "";

  /// 当前通话的类型
//  int mCurCallType = TYPE_UNKNOWN;

  /// 当前群组通话的群组ID
  String mCurGroupId = "";

  /// 最近使用的通话信令，用于快速处理
//  CallModel mLastCallModel = new CallModel();

  /// 上层传入回调
  InternalListenerManager internalListenerManager;
  String mNickName;
  String mFaceUrl;

  bool mIsUseFrontCamera;

  bool mWaitingLastActivityFinished;
  bool mIsInitIMSDK;

  bool isWaitingLastActivityFinished() {
    return mWaitingLastActivityFinished;
  }

  void setWaitingLastActivityFinished(bool waiting) {
    mWaitingLastActivityFinished = waiting;
  }

  @override
  void accept() {
    // TODO: implement accept
  }

  @override
  void addDelegate(TRTCCallingDelegate delegate) {
    // TODO: implement addDelegate
  }

  @override
  void call(String userId, CallType type) {
    // TODO: implement call
  }

  @override
  void closeCamera() {
    // TODO: implement closeCamera
  }

  @override
  void destroy() {
    // TODO: implement destroy
  }

  @override
  void groupCall(List<String> userIdList, CallType callType, String groupId) {
    // TODO: implement groupCall
  }

  @override
  void hangup() {
    // TODO: implement hangup
  }

  @override
  void login(int appId, String userId, String userSign, ActionCallBack callBack) {
    // TODO: implement login
  }

  @override
  void logout(ActionCallBack callBack) {
    // TODO: implement logout
  }

  @override
  void openCamera(bool isFrontCamera, Widget widget) {
    // TODO: implement openCamera
  }

  @override
  void reject() {
    // TODO: implement reject
  }

  @override
  void removeDelegate(TRTCCallingDelegate delegate) {
    // TODO: implement removeDelegate
  }

  @override
  void setHandsFree(bool isHandsFree) {
    // TODO: implement setHandsFree
  }

  @override
  void setMicMute(bool isMute) {
    // TODO: implement setMicMute
  }

  @override
  void startRemoteView(String userId, Widget widget) {
    // TODO: implement startRemoteView
  }

  @override
  void stopRemoteView(String userId) {
    // TODO: implement stopRemoteView
  }

  @override
  void switchCamera(bool isFrontCamera) {
    // TODO: implement switchCamera
  }
}
