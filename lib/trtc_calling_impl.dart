import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:tencent_im_plugin/entity/message_entity.dart';
import 'package:tencent_im_plugin/enums/message_node_type.dart';
import 'package:tencent_im_plugin/message_node/custom_message_node.dart';
import 'package:tencent_im_plugin/tencent_im_plugin.dart';
import 'package:tencent_rtc_plugin/entity/video_enc_param_entity.dart';
import 'package:tencent_rtc_plugin/tencent_rtc_plugin.dart';
import 'package:tencent_trtccalling_plugin/model/call_model.dart';
import 'package:tencent_trtccalling_plugin/model/calling_cache_data.dart';
import 'package:tencent_trtccalling_plugin/model/internal_listener_manager.dart';
import 'package:tencent_trtccalling_plugin/model/signaling_info.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling.dart';
import 'package:tencent_trtccalling_plugin/trtc_calling_delegate.dart';
import 'package:tencent_trtccalling_plugin/utils/collection_utils.dart';
import 'package:tencent_trtccalling_plugin/utils/string_utils.dart';

class TRTCCallingImpl extends TRTCCalling {
  Widget videoView;
  CallingCacheData cacheData = CallingCacheData();
  InternalListenerManager internalListenerManager;

  void imNewMessageListener(type, params) {
    if (type == ListenerTypeEnum.NewMessages) {
      MessageEntity message = params;
      var node = message.elemList[0];
      if (node.nodeType == MessageNodeType.Custom) {
        CustomMessageNode customNode = node;
        Map json = jsonDecode(customNode.data);
        if (json['key'] != SignalingInfo.signalMessageKey) {
          return;
        }
        var signalMessage = SignalingInfo().from(json);
        messageDispatch(signalMessage);
      }
    }
  }

  void messageDispatch(SignalingInfo data) {}

  @override
  void init() {
    TencentImPlugin.addListener(imNewMessageListener);
    internalListenerManager = InternalListenerManager();
    cacheData.lastCallModel.version = CallModel.VALUE_PROTOCOL_VERSION;
  }

  @override
  void destroy() {
    TencentImPlugin.removeListener(imNewMessageListener);
    TencentRtcPlugin.stopLocalAudio();
    TencentRtcPlugin.exitRoom();
  }

  @override
  void addDelegate(TRTCCallingDelegate delegate) {
    internalListenerManager.addDelegate(delegate);
  }

  @override
  void removeDelegate(TRTCCallingDelegate delegate) {
    internalListenerManager.removeDelegate(delegate);
  }

  @override
  void accept() {
    _sendMessage(cacheData.currentSponsorForMe, CallActionType.ACCEPT, null);
    _enterRoom();
  }

  @override
  void reject() {
    _sendMessage(cacheData.currentSponsorForMe, CallActionType.REJECT, null);
    cacheData.reset();
  }

  @override
  void hangup() {
    if (!cacheData.isOnCalling) {
      reject();
      return;
    }
    var isGroupCall = StringUtils.isNotEmpty(cacheData.currentGroupId);
    isGroupCall ? _groupHangup() : _singleHangup();
  }

  _groupHangup() {
    if (CollectionUtils.isEmpty(cacheData.currentRoomRemoteUserSet)) {
      _sendMessage("", CallActionType.SPONSOR_CANCEL, null);
    }
    cacheData.reset();
    _exitRoom();
  }

  _singleHangup() {
    cacheData.currentInvitedList.forEach((element) {
      _sendMessage(element, CallActionType.SPONSOR_CANCEL, null);
    });
    cacheData.reset();
    _exitRoom();
  }

  @override
  void call(String userId, CallType type) {
    if (StringUtils.isNotEmpty(userId)) {
      _internalCall(List()..add(userId), type, '');
    }
  }

  @override
  void openCamera(bool isFrontCamera, Widget widget) {
    if (widget != null) {
      videoView = widget;
    }
  }

  @override
  void closeCamera() {}

  @override
  void groupCall(List<String> userIdList, CallType callType, String groupId) {
    if (CollectionUtils.isNotEmpty(userIdList)) {
      _internalCall(userIdList, callType, groupId);
    }
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
  void setHandsFree(bool isHandsFree) {
    // TODO: implement setHandsFree
  }

  @override
  void setMicMute(bool isMute) {
    TencentRtcPlugin.muteLocalAudio(mute: isMute);
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
    if (cacheData.currentIsUseFrontCamera != isFrontCamera) {
      cacheData.currentIsUseFrontCamera = isFrontCamera;
      //todo switchCamera
    }
  }

  _enterRoom() {
    if (cacheData.currentCallType == CallType.VIDEO) {
      print('video');
      VideoEncParamEntity paramEntity = VideoEncParamEntity();
      // todo 查询对应的数值填充
      paramEntity.videoResolution = 1;
      paramEntity.videoResolutionMode = 1;
      paramEntity.videoFps = 15;
      paramEntity.videoBitrate = 1000;
      TencentRtcPlugin.setVideoEncoderParam(param: paramEntity);
    }
    TencentRtcPlugin.enableAudioVolumeEvaluation(intervalMs: 300);
    TencentRtcPlugin.setAudioRoute(route: 1);
    TencentRtcPlugin.startLocalAudio();
    // todo 添加参数
//    TencentRtcPlugin.enterRoom(appid: null, userId: cacheData., userSig: null, roomId: null, scene: null);
  }

  _processInvite(String inviteId, String inviter, String groupId, List<String> invitees, SignalingInfo signaling) {
    /// todo 添加trtc的监听
    CallModel model = _createModel(inviteId, groupId, invitees, signaling);
    if (signaling.callEnd) {
      _preExitRoom(null);
      return;
    }
    _handleDialing(model, inviter);
    if (cacheData.currentCallerId == model.callId) {
      cacheData.lastCallModel = model.clone();
    }
  }

  _handleDialing(CallModel model, String inviter) {
    if (StringUtils.isNotEmpty(cacheData.currentCallerId)) {
      if (cacheData.isOnCalling && model.invitedList.contains(cacheData.currentLoginUserId)) {
        _sendMessage(inviter, CallActionType.LINE_BUSY, model);
        return;
      }
      if (StringUtils.isNotEmpty(cacheData.currentGroupId) &&
          StringUtils.isNotEmpty(model.groupId) &&
          cacheData.currentGroupId == model.groupId) {
        cacheData.currentInvitedList.addAll(model.invitedList);
        internalListenerManager?.onGroupCallInviteeListUpdate(cacheData.currentInvitedList);
        return;
      }
    }

    /// 虽然是群组聊天，但是对方并没有邀请我，我不做处理
    if (StringUtils.isNotEmpty(model.groupId) && !model.invitedList.contains(cacheData.currentLoginUserId)) {
      return;
    }
    cacheData.startCall();
    cacheData.updateFromModel(model);
    internalListenerManager?.onInvited(inviter, model.invitedList, cacheData.isGroup, model.callType);
  }

  _preExitRoom(String leaveUserId) {
    if (StringUtils.isEmpty(leaveUserId)) {
      return;
    }
    if (cacheData.currentRoomRemoteUserSet.isEmpty && cacheData.currentInvitedList.isEmpty && cacheData.isInRoom) {
      if (cacheData.isGroup) {
        _sendMessage('', CallActionType.HANGUP, null);
      } else {
        _sendMessage(leaveUserId, CallActionType.HANGUP, null);
      }
      _exitRoom();
      cacheData.reset();
      internalListenerManager?.onCallEnd();
    }
  }

  _exitRoom() {
    /// todo 完善
//    mTRTCCloud.stopLocalPreview();
//    mTRTCCloud.stopLocalAudio();
//    mTRTCCloud.exitRoom();
  }

  _internalCall(List userIds, CallType type, String groupId) {
    //todo
  }

  _sendMessage(String userId, CallActionType actionType, CallModel model) {
    // todo
  }

  CallModel _createModel(String inviteId, String groupId, List<String> invitees, SignalingInfo signaling) {
    CallModel model = CallModel();
    model.callId = inviteId;
    model.groupId = groupId;
    model.action = CallActionType.DIALING;
    model.invitedList = invitees;
    model.version = signaling.version;
    model.callType = signaling.callType;
    model.roomId = signaling.roomId;
    return model;
  }
}
