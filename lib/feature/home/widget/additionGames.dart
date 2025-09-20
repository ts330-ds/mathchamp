import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MathExamplesGridPage extends StatelessWidget {
  List<(String,String,Color,int,String)> list;
  MathExamplesGridPage({super.key,required this.list});

  @override
  Widget build(BuildContext context) {
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

            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Selected: $example")),
                );
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
}
