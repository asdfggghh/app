import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class VoiceService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _initialized = false;

  Future<bool> init() async {
    _initialized = await _speech.initialize();
    return _initialized;
  }

  bool get isAvailable => _initialized && _speech.isAvailable;

  void startListening(Function(String recognizedText) onResult) {
    if (!_initialized) return;
    _speech.listen(onResult: (result) {
      if (result.finalResult) {
        onResult(result.recognizedWords);
      } else {
        // you could update intermediate results too
      }
    });
  }

  void stop() {
    _speech.stop();
  }
}
