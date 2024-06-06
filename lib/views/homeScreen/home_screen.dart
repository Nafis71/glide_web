import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glide_web/models/bookmark_models.dart';
import 'package:glide_web/utils/app_assets.dart';
import 'package:glide_web/utils/app_strings.dart';
import 'package:glide_web/utils/routes.dart';
import 'package:glide_web/viewModels/news_view_model.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
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
  @override
  void initState() {
    super.initState();
    newsViewModel = Provider.of<NewsViewModel>(context,listen: false);
    fetchNews();
  }

  Future<void> fetchNews() async{
    await fetch();
  }
  Future<void> fetch() async{
    await newsViewModel.getNews();
  }


  @override
  Widget build(BuildContext context) {
    print("Rebuilding");
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const SVGImageLoader(asset: AppAssets.backGroundImage, fit: BoxFit.cover),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.21,
            left: MediaQuery.of(context).size.width * 0.1,
            child: SizedBox(
              height: 170,
              width: 300,
              child: Image.asset(AppAssets.logo,fit: BoxFit.cover,),
            ),
          )
        ],
      ),
      bottomSheet: BottomSheet(
        backgroundColor: const Color(0xFFFAFAFA),
        onClosing: () {  }, builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(50),
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
                          Navigator.pushReplacementNamed(context, Routes.webViewScreen);
                        },
                      );
                    },),
                  ),
                  const Gap(20),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width *0.9,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                      return Consumer<WebViewModel>(builder: (_,viewModel,__){
                        return InkWell(
                          splashColor : Colors.transparent,
                          onTap: (){
                            viewModel.setUrl = bookmarkModels[index]["url"]!;
                            Navigator.pushReplacementNamed(context, Routes.webViewScreen);
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: Image.asset(bookmarkModels[index]["logo"]!,fit: BoxFit.cover,),
                                ),
                              ),
                              Text(bookmarkModels[index]["name"]!,style: const TextStyle(fontSize: 13),)
                            ],
                          ),
                        );
                      });
                    }, separatorBuilder: (context,index){ return const Gap(10);}, itemCount: bookmarkModels.length),
                  ),
                  const Gap(10),
                  Text("Top News",style: Theme.of(context).textTheme.titleLarge,),
                  const Gap(10),
                  const NewsLayout()
                ],
              ),
            ),
          ),
        );
      },),
    );
  }
}
