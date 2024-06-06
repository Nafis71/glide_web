import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../models/bookmark_models.dart';
import '../../utils/routes.dart';
import '../../viewModels/web_view_model.dart';

class BookmarkLayout extends StatelessWidget {
  const BookmarkLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
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
                  Navigator.pushNamed(context, Routes.webViewScreen);
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
    );
  }
}
