import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glide_web/models/bookmark_models.dart';
import 'package:glide_web/utils/app_assets.dart';
import 'package:glide_web/utils/app_strings.dart';
import 'package:glide_web/utils/routes.dart';
import 'package:glide_web/viewModels/news_view_model.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
import 'package:glide_web/views/homeScreen/bookmark_layout.dart';
import 'package:glide_web/views/homeScreen/news_layout.dart';
import 'package:glide_web/wrappers/svg_image_loader.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final NewsViewModel newsViewModel;
  late final WebViewModel webViewModel;
  @override
  void initState() {
    super.initState();
    newsViewModel = Provider.of<NewsViewModel>(context,listen: false);
    webViewModel = Provider.of<WebViewModel>(context,listen: false);
    fetchNews();
  }

  Future<void> fetchNews() async{
    await newsViewModel.getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const SVGImageLoader(asset: AppAssets.backGroundImage, fit: BoxFit.cover),
          SingleChildScrollView(
            child: Column(
              children: [
                Gap(MediaQuery.of(context).size.height * 0.15),
                SizedBox(
                  height: 170,
                  width: 300,
                  child: Image.asset(AppAssets.logo,fit: BoxFit.cover,),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Consumer<WebViewModel>(builder: (_,viewModel,__){
                          return TextField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: AppStrings.homeScreenSearchFieldHint,
                                filled: false,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey,width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.grey,width: 1),
                                  borderRadius: BorderRadius.circular(30),
                                )
                            ),
                            onSubmitted: (value){
                              viewModel.setUrl = value;
                              Navigator.pushNamed(context, Routes.webViewScreen);
                            },
                          );
                        },),
                      ),
                      const BookmarkLayout(),
                      const Gap(10),
                      Text(AppStrings.topNewsHeader,style: Theme.of(context).textTheme.titleLarge,),
                       NewsLayout(webViewModel: webViewModel,),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
