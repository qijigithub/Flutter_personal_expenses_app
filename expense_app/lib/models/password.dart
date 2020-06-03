import 'package:encrypt/encrypt.dart' as Passwords;


class Password {
  static String encrypt(String pswd) {
    const ENCRYPTION_KEY = "Z0tzXBdF1AKrgsgCsSki66NYbJBw7rbS";
    const PSWD_ENCRYPTION_LENGTH = 16;
    final key = Passwords.Key.fromUtf8(ENCRYPTION_KEY);
    final iv = Passwords.IV.fromLength(PSWD_ENCRYPTION_LENGTH);

    final encrypter = Passwords.Encrypter(Passwords.AES(key));

    final encrypted = encrypter.encrypt(pswd, iv: iv);

    return encrypted.base64;
  }

  static String decrypt(String encryptedPswd) {
      const ENCRYPTION_KEY = "Z0tzXBdF1AKrgsgCsSki66NYbJBw7rbS";
    const PSWD_ENCRYPTION_LENGTH = 16;
    final key = Passwords.Key.fromUtf8(ENCRYPTION_KEY);
    final iv = Passwords.IV.fromLength(PSWD_ENCRYPTION_LENGTH);

    final encrypter = Passwords.Encrypter(Passwords.AES(key));

    return encrypter.decrypt64(encryptedPswd, iv: iv);
  }
}