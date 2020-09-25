import 'package:tencent_trtccalling_plugin/model/signaling_info.dart';

abstract class SignalingListener {
  /// 收到新的通话请求
  void onReceiveNewInvitation(
      String inviteId, String inviter, String groupId, List<String> inviteeList, SignalingInfo data) {}

  /// 通话接收方已经接受通话请求
  void onInviteeAccepted(String inviteId, String invitee, SignalingInfo data) {}

  /// 通话接收方已经拒绝通话请求
  void onInviteeRejected(String inviteId, String invitee, SignalingInfo data) {}

  /// 通话发起方取消了通话请求
  void onInvitationCancelled(String inviteId, String inviter, SignalingInfo data) {}

  /// 通话发起方超时
  void onInvitationTimeout(String inviteId, List<String> inviteeList) {}
}
