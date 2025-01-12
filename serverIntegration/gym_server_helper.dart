import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:gym_app_flutter/sqlite_helper.dart';



class ServerHelper {
  late WebSocket _webSocket;
  bool _isConnected = false;
  final String _serverUrl = 'ws://10.0.2.2:3001';

  ServerHelper() {
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    try {
      debugPrint('Connecting to WebSocket...');
      _webSocket = await WebSocket.connect(_serverUrl);
      _isConnected = true;

      _webSocket.listen(
        _onMessageReceived,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: true,
      );

      debugPrint('WebSocket connection established.');
    } catch (e) {
      debugPrint('WebSocket connection failed: $e');
      _reconnectWebSocket();
    }
  }

  void _onMessageReceived(dynamic message) {
    try {
      debugPrint('WebSocket message received: $message');
      final decodedMessage = jsonDecode(message);
      _handleServerMessage(decodedMessage);
    } catch (e) {
      debugPrint('Error decoding WebSocket message: $e');
    }
  }


  void _onError(error) {
    debugPrint('WebSocket error: $error');
    _isConnected = false;
    _reconnectWebSocket();
  }

  void _onDone() {
    debugPrint('WebSocket connection closed.');
    _isConnected = false;
    _reconnectWebSocket();
  }

  Future<void> _reconnectWebSocket() async {
    await Future.delayed(Duration(seconds: 5));
    _initializeWebSocket();
  }

  void _handleServerMessage(Map<String, dynamic> message) {
    final action = message['action'];
    final data = message['data'];
    switch (action) {
      case 'add':
        SQLiteHelper().addGym(data);
        break;
      case 'update':
        final id = data['id'];
        SQLiteHelper().updateGym(id, data);
        break;
      case 'delete':
        final id = message['id'];
        SQLiteHelper().deleteGym(id);
        break;
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_isConnected) {
      _webSocket.add(jsonEncode(message));
    } else {
      debugPrint('WebSocket is not connected. Message not sent.');
    }
  }

  // Add a gym and notify the server
  Future<void> addGym(Map<String, dynamic> gym) async {
    try {
      sendMessage({
        'action': 'add',
        'data': gym,
      });
      debugPrint('Gym addition sent to server: $gym');
    } catch (e) {
      debugPrint('Error sending addGym message: $e');
    }
  }

  // Update a gym and notify the server
  Future<void> updateGym(String id, Map<String, dynamic> updatedData) async {
    try {
      sendMessage({
        'action': 'update',
        'data': {
          'id': id,
          ...updatedData,
        },
      });
      debugPrint('Gym update sent to server for ID: $id');
    } catch (e) {
      debugPrint('Error sending updateGym message: $e');
    }
  }

  // Delete a gym and notify the server
  Future<void> deleteGym(String id) async {
    try {
      sendMessage({
        'action': 'delete',
        'id': id,
      });
      debugPrint('Gym deletion sent to server for ID: $id');
    } catch (e) {
      debugPrint('Error sending deleteGym message: $e');
    }
  }
}
