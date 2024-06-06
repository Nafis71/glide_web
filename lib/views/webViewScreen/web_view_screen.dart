import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
import 'package:provider/provider.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final InAppWebViewController _webViewController;
  final urlController = TextEditingController();

  @override
  void initState() {
    urlController.text = context.read<WebViewModel>().url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.home_outlined,
                size: 27,
              ),
            ),
            const Gap(5),
            SizedBox(
              height: 40,
              width: screenWidth * 0.55,
              child: TextField(
                style: const TextStyle(
                  fontSize: 14.5
                ),
                controller: urlController,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _webViewController.loadUrl(
                        urlRequest: URLRequest(
                            url: WebUri("https://${urlController.text}")));
                  }
                },
                onTap: () {
                  urlController.clear();
                },
                onTapOutside: (value) {
                  urlController.text = context.read<WebViewModel>().url;
                  FocusScope.of(context).unfocus();
                },
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.network_check_rounded,size: 20,)),
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              _webViewController.loadUrl(
                  urlRequest: URLRequest(url: WebUri(urlController.text)));
            },
            child: const Icon(Icons.refresh),
          ),
          const Gap(8),
          Consumer<WebViewModel>(builder: (_,viewModel,__){
            if(viewModel.hasFinishedTalking){
              urlController.text = viewModel.url;
              _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(viewModel.url)));
              viewModel.hasFinishedTalking = false;
            }
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () async{
                await viewModel.initSpeech();
              },
              child: const Icon(Icons.mic_outlined),
            );
          }),
          const Gap(8),
          const Icon(Icons.more_vert),
          const Gap(8),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Consumer<WebViewModel>(builder: (_, viewModel, __) {
            return InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri(viewModel.url, forceToStringRawValue: false)),
              initialSettings: InAppWebViewSettings(
                  cacheEnabled: true,
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  mediaPlaybackRequiresUserGesture: false,
                  supportZoom: true,
                  useShouldOverrideUrlLoading: false),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                viewModel.setUrl = url.toString();
                urlController.text = url.toString();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  viewModel.setIsLoading(false, progress.toDouble() / 100);
                } else {
                  viewModel.setIsLoading(true, progress.toDouble() / 100);
                }
              },
            );
          }),
          Consumer<WebViewModel>(builder: (_, viewModel, __) {
            if (viewModel.isLoading) {
              return LinearProgressIndicator(
                color: Colors.white,
                value: viewModel.progress,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
              );
            }
            return const SizedBox.shrink();
          })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _webViewController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
