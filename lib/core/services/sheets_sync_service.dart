import 'dart:convert';
import 'package:http/http.dart' as http;

/// Sends a batch of order rows to the Google Apps Script Web App.
///
/// [webAppUrl] — the deployment URL from Apps Script
///   (e.g. `https://script.google.com/macros/s/ABC.../exec`)
///
/// [summaryRows] — one map per order with keys:
///   orderId, customerId, total, discount, note, status, createdAt
///
/// [detailRows] — one map per order item with keys:
///   orderId, itemId, productName, qty, unitPrice,
///   size, iceLevel, sweetLevel, toppings, itemTotal
///
/// Throws an [Exception] if the HTTP call fails or the script returns an error.
Future<void> postOrdersToSheet({
  required String webAppUrl,
  required List<Map<String, dynamic>> summaryRows,
  required List<Map<String, dynamic>> detailRows,
}) async {
  final uri = Uri.parse(webAppUrl);
  final client = http.Client();

  try {
    final request = http.Request('POST', uri)
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'summaryRows': summaryRows,
        'detailRows': detailRows,
      });
    // Don't auto-follow — POST redirects are unreliable in Dart's http pkg.
    request.followRedirects = false;

    final streamed =
        await client.send(request).timeout(const Duration(seconds: 30));

    http.Response response;

    // Google Apps Script always 302-redirects POST responses.
    // Manually follow the redirect with GET.
    if (streamed.statusCode == 302 || streamed.statusCode == 301) {
      final location = streamed.headers['location'];
      if (location == null) {
        throw Exception('Redirect with no Location header');
      }
      response = await client
          .get(Uri.parse(location))
          .timeout(const Duration(seconds: 15));
    } else {
      response = await http.Response.fromStream(streamed);
    }

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['status'] != 'ok') {
      throw Exception(json['message'] ?? 'Apps Script returned an error');
    }
  } finally {
    client.close();
  }
}
