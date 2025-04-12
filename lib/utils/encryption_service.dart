// lib/utils/encryption_service.dart
import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionService {
  static final key = encrypt.Key.fromUtf8('kodonomadsecurekey32byteslong!!!'); // 32 bytes for AES-256
  static final iv = encrypt.IV.fromLength(16);
  static final encrypter = encrypt.Encrypter(encrypt.AES(key));

  // Encrypt location data (latitude, longitude)
  static String encryptLocation(double lat, double lng) {
    final locationString = '$lat,$lng';
    return encrypter.encrypt(locationString, iv: iv).base64;
  }

  // Decrypt location data
  static List<double> decryptLocation(String encrypted) {
    final decrypted = encrypter.decrypt64(encrypted, iv: iv);
    final parts = decrypted.split(',');
    return [double.parse(parts[0]), double.parse(parts[1])];
  }
}
