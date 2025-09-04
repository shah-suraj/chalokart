import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis_auth/auth_io.dart';

class GetServiceKey {
  Future<String> getServerKeyToken() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": dotenv.env['GOOGLE_CLOUD_PROJECT_ID'],
        "private_key_id": dotenv.env['GOOGLE_CLOUD_PRIVATE_KEY_ID'],
        "private_key": dotenv.env['GOOGLE_CLOUD_PRIVATE_KEY'],
        "client_email": dotenv.env['GOOGLE_CLOUD_CLIENT_EMAIL'],
        "client_id": dotenv.env['GOOGLE_CLOUD_CLIENT_ID'],
        "auth_uri": dotenv.env['GOOGLE_CLOUD_AUTH_URI'],
        "token_uri": dotenv.env['GOOGLE_CLOUD_TOKEN_URI'],
        "auth_provider_x509_cert_url":
            dotenv.env['GOOGLE_CLOUD_AUTH_PROVIDER_X509_CERT_URL'],
        "client_x509_cert_url": dotenv.env['GOOGLE_CLOUD_CLIENT_X509_CERT_URL'],
        "universe_domain": dotenv.env['GOOGLE_CLOUD_UNIVERSE_DOMAIN'],
      }),
      scopes,
    );
    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
