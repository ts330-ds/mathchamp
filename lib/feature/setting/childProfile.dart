import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/feature/setting/settingScreen.dart';
import 'package:mathchamp/main.dart';

import '../../customPainter/backButtonDesign.dart';
import '../../custom_widget/backButton3D.dart';
import '../../custom_widget/decorations.dart';

class ChildProfile extends StatefulWidget {
  const ChildProfile({super.key});

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {


  List<String> names=[];
  // Load names from SharedPreferences
  Future<void> _loadNames() async {
    setState(() {
      names = prefs.getStringList('names') ?? [];
    });
  }

  // Save names to SharedPreferences
  Future<void> _saveNames() async {
    await prefs.setStringList('names', names);
  }

  Future<void> _deleteName(int index) async{
    try{
      names.removeAt(index);
      await prefs.setStringList('names', names);
      setState((){
      });
    }catch(e){
      print("index not found ${e.toString()}");
    }
  }
  // Show dialog to add name
  void _showAddNameDialog([String? names,int? index]) {
    final TextEditingController controller = TextEditingController();
    if(names!=null) controller.text = names;
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        title: const Text("Add Name"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration:  InputDecoration(
          labelText: "Name",
          hintText: "Enter a name",
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(), // cancel
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                if(index!=null){
                  context.read<SettingsCubit>().updateUser(name, index);
                }else{
                  context.read<SettingsCubit>().addUser(name);
                }
              }
              context.pop(); // close dialog
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _loadNames();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: BlocBuilder<SettingsCubit,SettingsState>(
            builder: (context,state) {
              final cubit = context.read<SettingsCubit>();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomBackButton(
                        onPressed: () => context.pop(),
                        painters: SquareButtonPainter(context: context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("Add Child", style: Theme.of(context).textTheme.headlineMedium),
                        ),
                      ),
                      CustomBackButton(
                        onPressed: () {
                          _showAddNameDialog();
                        },
                        painters: SquareButtonPainter(context: context),
                        iconData: Icons.add,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: ConDecorations.conSimpleDecoration(color: Theme.of(context).colorScheme.surface),
                            padding: EdgeInsets.all(10),
                            width: size.width.w - 50.w,
                            height: size.height / 2.w,
                            child: state.userList.isNotEmpty?ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: ScrollPhysics(),
                              itemCount: state.userList.length,
                              itemBuilder: (context, index) {
                                return  Card(
                                  color: Colors.blue[50], // ✅ background color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title:  Text(state.userList[index],style: Theme.of(context).textTheme.labelLarge,),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Colors.green),
                                          onPressed: () {
                                            _showAddNameDialog(state.userList[index],index);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            cubit.removeUser(index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ):Center(
                              child: Text("No Name Found"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }


}
