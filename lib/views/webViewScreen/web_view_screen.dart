import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:gap/gap.dart';
import 'package:glide_web/utils/app_strings.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
import 'package:glide_web/views/widgets/mic_alert_dialog.dart';
import 'package:provider/provider.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final InAppWebViewController _webViewController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final urlController = TextEditingController();
  bool isMicPressed = false;
  String recognizedWords = "";

  @override
  void initState() {
    urlController.text = context.read<WebViewModel>().url;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
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
              width: screenWidth * 0.6,
              child: TextField(
                style: const TextStyle(fontSize: 14.5),
                controller: urlController,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _webViewController.loadUrl(
                        urlRequest: URLRequest(
                            url: WebUri(context.read<WebViewModel>().processUrl(urlController.text))));
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
                  prefixIcon: Icon(
                    Icons.network_check_rounded,
                    size: 20,
                  ),
                ),
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
          const Gap(15),
          Consumer<WebViewModel>(builder: (_, viewModel, __) {
            if (viewModel.hasFinishedTalking) {
              urlController.text = viewModel.url;
              _webViewController.loadUrl(
                  urlRequest: URLRequest(url: WebUri(viewModel.url)));
              viewModel.hasFinishedTalking = false;
            }
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                showAlertDialog();
              },
              child: const Icon(Icons.mic_outlined),
            );
          }),
          const Gap(15),
        ],
        automaticallyImplyLeading: false,
      ),
      body:  PopScope(
        canPop: false,
        onPopInvoked: (bool isPop) async{
          bool canGoBack =  await _webViewController.canGoBack();
          if(canGoBack && mounted){
            _webViewController.goBack();
            return;
          }
          if(context.mounted && Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
        child: Stack(
        children: [
          Consumer<WebViewModel>(builder: (_, viewModel, __) {
            return InAppWebView(
              initialUrlRequest: URLRequest(
                  url: WebUri(viewModel.processUrl(viewModel.url), forceToStringRawValue: false)),
              initialSettings: InAppWebViewSettings(
                  cacheEnabled: true,
                  javaScriptEnabled: true,
                  useOnDownloadStart: true,
                  mediaPlaybackRequiresUserGesture: false,
                  supportZoom: true,
                  allowBackgroundAudioPlaying: true,
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
          Consumer<WebViewModel>(
            builder: (_, viewModel, __) {
              if (viewModel.isLoading) {
                return LinearProgressIndicator(
                  color: Colors.white,
                  value: viewModel.progress,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                );
              }
              return const SizedBox.shrink();
            },
          )
        ],
      ),

      )
    );
  }

  void showAlertDialog() {
    recognizedWords = "";
    final WebViewModel webViewModel =
        Provider.of<WebViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (isMicPressed) {
              webViewModel.initSpeech();
              Future.delayed(
                const Duration(seconds: 4),
                () {
                  setDialogState(
                    () {
                      isMicPressed = false;
                      recognizedWords = webViewModel.recognizedWords;
                    },
                  );
                },
              );
            }
            return MicAlertDialog(
              titleTextWidget: (!isMicPressed)
                  ? Text(AppStrings.micAlertDialogTitleTextTalk, style: Theme.of(context).textTheme.titleLarge)
                  : Text(AppStrings.micAlertDialogTitleTextListening,
                      style: Theme.of(context).textTheme.titleLarge),
              contentTextWidget:
                  (!isMicPressed) ? Text(recognizedWords) : const Text(""),
              micOnPressed: () {
                setDialogState(
                  () {
                    isMicPressed = !isMicPressed;
                  },
                );
              },
              webViewModel: webViewModel,
              micIconWidget: (!isMicPressed)
                  ? const Icon(
                      Icons.mic_none_outlined,
                      size: 45,
                    )
                  : const Icon(Icons.mic_outlined, size: 45),
              cancelFunction: () {
                recognizedWords = "";
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _webViewController.dispose();
    urlController.dispose();
    super.dispose();
  }
}
