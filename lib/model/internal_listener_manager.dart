import 'package:tencent_trtccalling_plugin/trtc_calling.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling_delegate.dart';

class InternalListenerManager implements TRTCCallingDelegate {
  Expando<List> delegateWeakReference = Expando<List>();

  InternalListenerManager() {
    delegateWeakReference[this] = List<TRTCCallingDelegate>();
  }

  void addDelegate(TRTCCallingDelegate delegate) {
    if (!delegateWeakReference[this].contains(delegate)) {
      delegateWeakReference[this].add(delegate);
    }
  }

  void removeDelegate(TRTCCallingDelegate delegate) {
    delegateWeakReference[this].remove(delegate);
  }

  @override
  void onCallEnd() {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onCallEnd();
    }
  }

  @override
  void onCallingCancel() {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onCallingCancel();
    }
  }

  @override
  void onCallingTimeout() {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onCallingTimeout();
    }
  }

  @override
  void onError(int code, String msg) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onError(code, msg);
    }
  }

  @override
  void onGroupCallInviteeListUpdate(List<String> userIdList) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onGroupCallInviteeListUpdate(userIdList);
    }
  }

  @override
  void onInvited(String sponsor, List<String> userIdList, bool isFromGroup, CallType callType) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onInvited(sponsor, userIdList, isFromGroup, callType);
    }
  }

  @override
  void onLineBusy(String userId) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onLineBusy(userId);
    }
  }

  @override
  void onNoResp(String userId) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onNoResp(userId);
    }
  }

  @override
  void onReject(String userId) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onReject(userId);
    }
  }

  @override
  void onUserAudioAvailable(String userId, bool isVideoAvailable) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onUserAudioAvailable(userId, isVideoAvailable);
    }
  }

  @override
  void onUserEnter(String userId) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onUserEnter(userId);
    }
  }

  @override
  void onUserLeave(String userId) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onUserLeave(userId);
    }
  }

  @override
  void onUserVideoAvailable(String userId, bool isVideoAvailable) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onUserVideoAvailable(userId, isVideoAvailable);
    }
  }

  @override
  void onUserVoiceVolume(Map<String, int> volumeMap) {
    for (TRTCCallingDelegate delegate in delegateWeakReference[this]) {
      delegate?.onUserVoiceVolume(volumeMap);
    }
  }
}
