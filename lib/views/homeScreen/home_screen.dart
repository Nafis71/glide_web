import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final InAppWebViewController _webViewController;
  final urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.home_outlined,
                  size: 27,
                )),
            SizedBox(
              height: 40,
              width: screenWidth * 0.5,
              child: TextField(
                controller: urlController,
                onSubmitted: (value){
                  _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri("https://${urlController.text}")));
                },
                onTapOutside: (value){
                  FocusScope.of(context).unfocus();
                },
                decoration:
                    const InputDecoration(prefixIcon: Icon(Icons.tune_outlined)),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.mic_outlined,
                size: 26,
              )),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 26,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<WebViewModel>(builder: (_, viewModel, __) {
            return InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri('https://www.google.com/',
                      forceToStringRawValue: false)),
              initialSettings: InAppWebViewSettings(
                  cacheEnabled: true,
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  mediaPlaybackRequiresUserGesture: false,
                  supportZoom: false,
                  useShouldOverrideUrlLoading: false),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                viewModel.setUrl = url.toString();
                urlController.text = url.toString();
              },
              onProgressChanged: (controller,progress){
                if(progress ==100){
                  viewModel.setIsLoading(false, progress.toDouble()/100);
                } else{
                  print(progress);
                  viewModel.setIsLoading(true, progress.toDouble()/100);
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
}
