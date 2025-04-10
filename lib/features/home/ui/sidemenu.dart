import 'package:flexpromoter/features/auth/repo/auth_repo.dart' as SharedPreferencesHelper;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../gen/colors.gen.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/widgets/app_text.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  List<SideItem> menuItems = [
    SideItem(
      title: 'Bookings',
      iconData: Icons.calendar_today,
      items: [
        SubCategoryMasterClass(
          widget: const SubCategory(
            title: 'All Bookings',
          ),
          route: Routes.bookings,
        ),
        SubCategoryMasterClass(
          widget: const SubCategory(
            title: 'Make Booking',
          ),
          route: Routes.makeBookings,
        ),
      ],
    ),
    SideItem(
      title: 'Commissions',
      iconData: Icons.monetization_on,
      items: [
        SubCategoryMasterClass(
          widget: const SubCategory(
            title: 'My Commissions',
          ),
          route: Routes.commissions,
        ),
      ],
    ),
    SideItem(
      title: 'Leaderboard',
      iconData: Icons.leaderboard,
      items: [
        SubCategoryMasterClass(
          widget: const SubCategory(
            title: 'Rankings',
          ),
          route: Routes.leaderboard,
        ),
      ],
    ),
  ];

  int selectedItem = -1;
  String? phone;
  String? name;

  getData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    phone = prefs.getString('phone');
    name = prefs.getString('name');
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? const Color(0xFF1A1A1A) : ColorName.primaryColor;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
              const BorderRadius.horizontal(left: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(-5, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            // Logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Image.asset(
                'assets/icon/flexlogo3.png',
                height: 50.h,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            // Profile Info Card with enhanced styling
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(15.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(
                        CupertinoIcons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.medium(
                          name ?? 'Promoter',
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        SizedBox(height: 4.h),
                        AppText.small(
                          phone ?? 'Profile',
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Menu Items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                itemCount: menuItems.length,
                itemBuilder: (context, i) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: selectedItem == i
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        key: Key(i.toString()),
                        onExpansionChanged: (value) {
                          setState(() => selectedItem = value ? i : -1);
                        },
                        iconColor: Colors.white,
                        collapsedIconColor: Colors.white.withOpacity(0.7),
                        leading: Icon(
                          menuItems[i].iconData,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        title: AppText.medium(
                          menuItems[i].title,
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                        children: menuItems[i]
                            .items
                            .map(
                              (item) => InkWell(
                                onTap: () =>
                                    Navigator.pushNamed(context, item.route),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 12.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6.w,
                                        height: 6.w,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 15.w),
                                      AppText.medium(
                                        (item.widget as SubCategory).title,
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Logout Button
            Container(
              margin: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () async {
                        await SharedPreferencesHelper.logout();
                        if (context.mounted) {
                          Navigator.pushReplacementNamed(context, Routes.login);
                        }
                      },
                 leading: Icon(
                  CupertinoIcons.power,
                  color: Colors.white,
                  size: 24.sp,
                ),
                title: AppText.medium(
                  "Logout",
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubCategoryMasterClass {
  Widget widget;
  String route;
  SubCategoryMasterClass({
    required this.widget,
    required this.route,
  });
}

class SubCategory extends StatelessWidget {
  const SubCategory({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 5,
        width: 5,
        decoration: const BoxDecoration(
          color: ColorName.whiteColor,
          shape: BoxShape.circle,
        ),
      ),
      title: AppText.medium(
        title,
        color: ColorName.mainGrey,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class SideItem {
  String title;
  IconData iconData;
  List<SubCategoryMasterClass> items;
  SideItem({required this.title, required this.iconData, required this.items});
}
