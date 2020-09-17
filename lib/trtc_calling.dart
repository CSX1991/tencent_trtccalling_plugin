import 'package:flutter/material.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling_delegate.dart';

/// TRTC 语音/视频通话接口
/// 本功能使用腾讯云实时音视频 / 腾讯云即时通信IM 组合实现
///
/// 使用方式如下
/// 1. 初始化
/// TRTCCalling sCall = TRTCCallingImpl.sharedInstance(context);
/// sCall.init();
///
/// 2. 监听回调
/// sCall.addDelegate(new TRTCCallingDelegate());
///
/// 3. 登录到IM系统中
/// sCall.login(A, password, callback);
///
/// 4. 给B拨打电话
/// sCall.call(B, TYPE_VIDEO_CALL);
///
/// 5. 打开自己的摄像头
/// sCall.openCamera(true, txCloudVideoView);
///
/// 6. 接听/拒绝电话
/// 此时B如果也登录了IM系统，会收到TRTCVideoCallListener的onInvited(A, null, false, TYPE_VIDEO_CALL)回调
/// B 可以调用 sCall.accept 接受 / sCall.reject 拒绝
///
/// 7. 观看对方的画面
/// 由于A打开了摄像头，B接受通话后会收到 onUserVideoAvailable(A, true) 回调
/// B 可以调用 startRemoteView(A, txCloudVideoView) 就可以看到A的画面了
///
/// 8. 结束通话
/// 需要结束通话时，A、B 任意一方可以调用 sCall.hangup 挂断电话
///
/// 9. 销毁实例
/// sCall.destroy();
/// TRTCCallingImpl.destroySharedInstance();
abstract class TRTCCalling {
  static final int TYPE_UNKNOWN = 0;
  static final int TYPE_AUDIO_CALL = 1;
  static final int TYPE_VIDEO_CALL = 2;

  static TRTCCalling sTRTCCalling;

  /// 获取单例
  static TRTCCalling shareInstance() {
    if (sTRTCCalling == null) {
      // sTRTCCalling = TRTCCalling();
    }
    return sTRTCCalling;
  }

  /// 销毁单例
  static void destroySharedInstance() {
    if (sTRTCCalling != null) {
      sTRTCCalling.destroy();
      sTRTCCalling = null;
    }
  }

  /// 销毁函数，如果不需要再运行该实例，请调用该接口
  void destroy();

  /// 增加回调接口
  /// delegate 上层可以通过回调监听事件
  void addDelegate(TRTCCallingDelegate delegate);

  /// 移除回调接口
  /// delegate 需要移除的监听器
  void removeDelegate(TRTCCallingDelegate delegate);

  /// 登录IM接口，所有功能需要先进行登录后才能使用
  void login(int appId, String userId, String userSign, ActionCallBack callBack);

  /// 登出接口，登出后无法再进行拨打操作
  void logout(ActionCallBack callBack);

  /// C2C邀请通话，被邀请方会收到 {@link TRTCCallingDelegate#onInvited } 的回调
  /// 如果当前处于通话中，可以调用该函数以邀请第三方进入通话
  ///
  /// userId 被邀请方
  /// type   语音通话 或者 视频通话
  void call(String userId, CallType type);

  /// IM群组邀请通话，被邀请方会收到 TRTCCallingDelegate#onInvited 的回调
  /// 如果当前处于通话中，可以继续调用该函数继续邀请他人进入通话，同时正在通话的用户会收到 TRTCCallingDelegate#onGroupCallInviteeListUpdate(List) 的回调
  ///
  /// userIdList 邀请列表
  /// type       1-语音通话，2-视频通话
  /// groupId    IM群组ID
  void groupCall(List<String> userIdList, CallType callType, String groupId);

  /// 当您作为被邀请方收到 TRTCCallingDelegate#onInvited 的回调时，可以调用该函数接听来电
  void accept();

  /// 当您作为被邀请方收到 TRTCCallingDelegate#onInvited 的回调时，可以调用该函数拒绝来电
  void reject();

  /// 当您处于通话中，可以调用该函数结束通话
  void hangup();

  /// 当您收到 onUserVideoAvailable 回调时，可以调用该函数将远端用户的摄像头数据渲染到指定的 Widget 中
  ///
  /// userId           远端用户id
  /// txCloudVideoView 远端用户数据将渲染到该view中
  void startRemoteView(String userId, Widget widget);

  /// 当您收到 onUserVideoAvailable 回调为false时，可以停止渲染数据
  ///
  /// userId 远端用户id
  void stopRemoteView(String userId);

  /// 您可以调用该函数开启摄像头，并渲染在指定的TXCloudVideoView中
  /// 处于通话中的用户会收到 {@link TRTCCallingDelegate#onUserVideoAvailable(java.lang.String, boolean)} 回调
  ///
  /// isFrontCamera    是否开启前置摄像头
  /// txCloudVideoView 摄像头的数据将渲染到该view中
  void openCamera(bool isFrontCamera, Widget widget);

  /// 您可以调用该函数关闭摄像头
  /// 处于通话中的用户会收到 {@link TRTCCallingDelegate#onUserVideoAvailable(java.lang.String, boolean)} 回调
  void closeCamera();

  /// 您可以调用该函数切换前后摄像头
  ///
  /// isFrontCamera true:切换前置摄像头 false:切换后置摄像头
  void switchCamera(bool isFrontCamera);

  /// 是否静音mic
  ///
  /// isMute true:麦克风关闭 false:麦克风打开
  void setMicMute(bool isMute);

  /// 是否开启免提
  ///
  /// isHandsFree true:开启免提 false:关闭免提
  void setHandsFree(bool isHandsFree);
}

enum CallType {
  // 语音
  VOICE,
  // 视频
  VIDEO,
}

abstract class ActionCallBack {
  void onError(int code, String message);

  void onSuccess();
}
