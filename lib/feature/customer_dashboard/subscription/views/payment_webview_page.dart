import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String url;
  final VoidCallback onSuccess;

  const PaymentWebViewPage({
    super.key,
    required this.url,
    required this.onSuccess,
  });

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            debugPrint('WebView Finished loading: $url');
            
            // Common success indicators based on screenshot: api/v1/payment/success
            if (url.contains('payment/success') || url.contains('checkout-success') || url.contains('paymentsuccess')) {
              debugPrint('Success URL detected: $url');
              // Just wait for a few seconds to let user see backend's own success popup
              Future.delayed(const Duration(seconds: 4), () {
                if (mounted) {
                  widget.onSuccess();
                  Get.back(); // Just close WebView and return to app
                }
              });
            } else if (url.contains('cancel') || url.contains('checkout-cancel')) {
              Get.back();
              Get.snackbar('Cancelled', 'Payment process was cancelled', 
                backgroundColor: Colors.orange, colorText: Colors.white);
            }
          },
          onWebResourceError: (WebResourceError error) {
             debugPrint('WebView Error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
