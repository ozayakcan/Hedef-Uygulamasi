import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hedef/utils/widgets.dart';

void loginError(BuildContext context, FirebaseAuthException e) {
  ScaffoldSnackbar.of(context).show('Giriş Başarısız! ${e.message}');
  if (kDebugMode) {
    print('Giriş Başarısız! Kod: ${e.code}');
    print(e.message);
  }
}

void loginError2(BuildContext context, PlatformException e) {
  if (kDebugMode) {
    print(e.message);
  }
}

String firebaseAuthMessages(String code) {
  if (code == "invalid-email") {
    return "Eposta geçersiz! Lütfen geçerli bir Eposta adresi girin!";
  } else if (code == "expired-action-code") {
    return "Kod zaman aşımına uğradı! Lütfen yeni kod alın!";
  } else if (code == "invalid-action-code") {
    return "Geçersiz kod! Lütfen kodu tekrar isteyin!";
  } else if (code == "user-disabled") {
    return "Kullanıcı devredışı bırakılmış!";
  } else if (code == "user-not-found") {
    return "Kullanıcı bulunamadı! Bu işlemi gerçekleştirmeden önce kaydolun!";
  } else if (code == "weak-password") {
    return "Girilen şifre zayıf! Lütfen daha güçlü bir şifre girin!";
  } else if (code == "email-already-in-use") {
    return "Eposta zaten kullanılıyor! Şifrenizi unuttuysanız lütfen şifre sıfırla butonuna basın!";
  } else if (code == "invalid-email") {
    return "Geçersiz eposta! Lütfen girdiğiniz eposta adresini kontrol edin!";
  } else if (code == "operation-not-allowed") {
    return "Bu işleme izin verilmiyor!";
  } else if (code == "account-exists-with-different-credential") {
    return "Hesap başka bir kimlik bilgileri ile zaten mevcut!";
  } else if (code == "credential-already-in-use") {
    return "Bu kimlik bilgisi zaten kullanımda!";
  } else if (code == "invalid-continue-uri") {
    return "İstekte bulunulan url geçersiz!";
  } else if (code == "unauthorized-continue-uri") {
    return "İstekte bulunulan url yetkilendirilmemiş";
  } else if (code == "invalid-credential") {
    return "Geçersiz kimlik bilgisi! Lütfen daha sonra tekrar deneyin!";
  } else if (code == "wrong-password") {
    return "Şifre yanlış!";
  } else if (code == "invalid-verification-code") {
    return "Doğrulama kodu geçersiz!";
  } else if (code == "cancelled-popup-request") {
    return "Açılır pencere isteği iptal edildi!";
  } else if (code == "popup-blocked") {
    return "Açılır pencere engellendi! Lütfen engellemeyi kaldırıp tekrar deneyin!";
  } else if (code == "popup-closed-by-user") {
    return "Giriş iptal edildi!";
  } else if (code == "unauthorized-domain") {
    return "Yetkisiz alan adı!";
  }
  return "Bir hata oluştu! Lütfen daha sonra tekrar deneyin!";
}
