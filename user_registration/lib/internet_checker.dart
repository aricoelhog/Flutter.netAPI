import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';

class InternetChecker {
  // Verifica se há conexão com a internet
  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      if (kDebugMode) print('Erro ao verificar conexão: $e');
      return false;
    }
  }

  // Aguarda até que haja conexão (útil para retry logic)
  static Future<void> waitForConnection({
    Duration checkInterval = const Duration(seconds: 3),
    int maxAttempts = 10,
  }) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      if (await hasConnection()) return;
      attempts++;
      await Future.delayed(checkInterval);
    }
    throw Exception('Não foi possível conectar após $maxAttempts tentativas');
  }
}
