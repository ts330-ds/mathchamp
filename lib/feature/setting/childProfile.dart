import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/main.dart';
import 'package:mathchamp/utils/custom_theme.dart';

class ChildProfile extends StatefulWidget {
  const ChildProfile({super.key});

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  List<String> names = [];

  Future<void> _loadNames() async {
    setState(() {
      names = prefs.getStringList('names') ?? [];
    });
  }

  Future<void> _saveNames() async {
    await prefs.setStringList('names', names);
  }

  Future<void> _deleteName(int index) async {
    try {
      names.removeAt(index);
      await prefs.setStringList('names', names);
      setState(() {});
    } catch (e) {
      print("index not found ${e.toString()}");
    }
  }

  void _showAddNameDialog([String? existingName, int? index]) {
    final TextEditingController controller = TextEditingController();
    if (existingName != null) controller.text = existingName;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    index != null ? '✏️' : '👋',
                    style: TextStyle(fontSize: 32.sp),
                  ),
                ),
              ),
              SizedBox(height: 16.w),
              Text(
                index != null ? 'Edit Profile' : 'New Player',
                style: GoogleFonts.fredoka(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                index != null
                    ? 'Update the player name'
                    : "What's your name, champ?",
                style: GoogleFonts.nunito(
                  fontSize: 14.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(height: 20.w),
              // Text field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  style: GoogleFonts.fredoka(
                    fontSize: 18.sp,
                    color: const Color(0xFF2D3436),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter name...',
                    hintStyle: GoogleFonts.nunito(
                      fontSize: 16.sp,
                      color: const Color(0xFF636E72),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Text('👤', style: TextStyle(fontSize: 20.sp)),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
                  ),
                ),
              ),
              SizedBox(height: 24.w),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.fredoka(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        final name = controller.text.trim();
                        if (name.isNotEmpty) {
                          if (index != null) {
                            context.read<SettingsCubit>().updateUser(name, index);
                          } else {
                            context.read<SettingsCubit>().addUser(name);
                          }
                        }
                        context.pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(16.w),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            index != null ? 'Update' : 'Add',
                            style: GoogleFonts.fredoka(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmDialog(int index, String name) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '😢',
                style: TextStyle(fontSize: 48.sp),
              ),
              SizedBox(height: 16.w),
              Text(
                'Remove Player?',
                style: GoogleFonts.fredoka(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                'Are you sure you want to remove\n"$name"?',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(height: 24.w),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        child: Center(
                          child: Text(
                            'Keep',
                            style: GoogleFonts.fredoka(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<SettingsCubit>().removeUser(index);
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                          ),
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        child: Center(
                          child: Text(
                            'Remove',
                            style: GoogleFonts.fredoka(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFE8F4FD),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context),
                    SizedBox(height: 24.w),
                    // Info Card
                    _buildInfoCard(),
                    SizedBox(height: 20.w),
                    // Profiles List Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Players',
                          style: GoogleFonts.fredoka(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        Text(
                          '${state.userList.length} profiles',
                          style: GoogleFonts.nunito(
                            fontSize: 14.sp,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.w),
                    // Profiles List
                    Expanded(
                      child: state.userList.isNotEmpty
                          ? ListView.builder(
                              itemCount: state.userList.length,
                              itemBuilder: (context, index) {
                                return _buildProfileCard(
                                  context,
                                  state.userList[index],
                                  index,
                                );
                              },
                            )
                          : _buildEmptyState(),
                    ),
                    // Add Button
                    SizedBox(height: 16.w),
                    _buildAddButton(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: const Color(0xFF6C63FF),
              size: 24.w,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            'Child Profiles',
            style: GoogleFonts.fredoka(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
        ),
        Text(
          '👨‍👩‍👧‍👦',
          style: TextStyle(fontSize: 32.sp),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14.w),
            ),
            child: Text(
              '💡',
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Family Play!',
                  style: GoogleFonts.fredoka(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Add profiles for each child to track their progress',
                  style: GoogleFonts.nunito(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, String name, int index) {
    Color avatarColor = MathChampTheme.quizCardColors[
        index % MathChampTheme.quizCardColors.length];

    return Container(
      margin: EdgeInsets.only(bottom: 12.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: avatarColor,
              borderRadius: BorderRadius.circular(15.w),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: GoogleFonts.fredoka(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Name
          Expanded(
            child: Text(
              name,
              style: GoogleFonts.fredoka(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
          ),
          // Action buttons
          Row(
            children: [
              GestureDetector(
                onTap: () => _showAddNameDialog(name, index),
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6BCB77).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Icon(
                    Icons.edit_rounded,
                    color: const Color(0xFF6BCB77),
                    size: 20.w,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _showDeleteConfirmDialog(index, name),
                child: Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: const Color(0xFFFF6B6B),
                    size: 20.w,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '👋',
            style: TextStyle(fontSize: 64.sp),
          ),
          SizedBox(height: 16.w),
          Text(
            'No Players Yet!',
            style: GoogleFonts.fredoka(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            'Add a player to get started',
            style: GoogleFonts.nunito(
              fontSize: 16.sp,
              color: const Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _showAddNameDialog(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 24.w,
            ),
            SizedBox(width: 8.w),
            Text(
              'Add New Player',
              style: GoogleFonts.fredoka(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
