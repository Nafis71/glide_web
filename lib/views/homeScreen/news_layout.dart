import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glide_web/utils/app_strings.dart';
import 'package:glide_web/utils/routes.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
import 'package:provider/provider.dart';

import '../../viewModels/news_view_model.dart';

class NewsLayout extends StatelessWidget {
  final WebViewModel webViewModel;
  const NewsLayout({super.key, required this.webViewModel});

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsViewModel>(
      builder: (_, viewModel, __) {
        return ListView.separated(
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          onTap: (){
                            webViewModel.setUrl = webViewModel.processUrl(viewModel.articles[index].url.toString());
                            Navigator.pushNamed(context, Routes.webViewScreen);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.95,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(viewModel
                                          .articles[index].urlToImage ??
                                      AppStrings.noImageLink),
                                  fit: BoxFit.fitHeight),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Text(
                      viewModel.articles[index].title.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const Gap(10);
            },
            itemCount: viewModel.articles.length);
      },
    );
  }
}
