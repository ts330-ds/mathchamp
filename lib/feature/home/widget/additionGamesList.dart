import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/ads/adsState.dart';
import 'package:mathchamp/feature/home/commonStartGameScreen.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/routes/paths.dart';

class AdditionalGameList extends StatelessWidget {
  List<(String,String,Color,int,int,String)> list;
  AdditionalGameList({super.key,required this.list});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdCubit,AdsState>(
      builder: (context,adsState) {
        final adCubit = context.read<AdCubit>();
        return BlocBuilder<GameDetailCubit,GameDetailState>(
            builder: (context,state) {
              final cubit = context.read<GameDetailCubit>();
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // ✅ 2 items per row
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.2, // adjust height vs width
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final title = item.$1;
                    final example = item.$2;
                    final color = item.$3;
                    final firstDigit = item.$4;
                    final lastDigit = item.$5;
                    final gameHeading = item.$6;

                    return GestureDetector(
                      onTap: () {
                        cubit.selectGameFromHome(gameHeading, firstDigit,lastDigit);

                        if (adCubit.state.interstitialAd != null) {
                          // Rewarded ad nahi hai → Interstitial show
                          adCubit.showInterstitial(() {
                            context.push(Paths.commonStartGameScreen);
                          });
                        } else {
                          // Agar koi ad loaded nahi → direct next screen
                          context.push(Paths.commonStartGameScreen);
                        }

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: color,
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.w),
                                    ),
                                    color: Colors.white
                                ),
                                child: Text(
                                  example,
                                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
        );

      }
    );
  }
}
