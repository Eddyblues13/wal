import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wal/common/routes/names.dart';
import 'package:wal/common/values/colors.dart';
import 'package:wal/pages/home/bloc/home_page_blocs.dart';
import 'package:wal/pages/home/home_controller.dart';
import 'package:wal/pages/home/widgets/home_page_widgets.dart';
import '../../common/entities/user.dart';
import '../../common/widgets/base_text_widget.dart' as res;
import 'bloc/home_page_states.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserItem userProfile;

  @override
  void initState() {
    super.initState();
    //_homeController = HomeController(context: context);
    //_homeController.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProfile = HomeController(context: context).userProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(userProfile.avatar.toString()),
      body: RefreshIndicator(
        onRefresh: () {
          return HomeController(context: context).init();
        },
        child: BlocBuilder<HomePageBlocs, HomePageStates>(
          builder: (context, state) {
            if (state.courseItem.isEmpty) {
              HomeController(context: context).init();
            }
            return Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 25.w),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: homePageText(
                      "Hello",
                      color: AppColors.primaryThirdElementText,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: homePageText(userProfile.name ?? "", top: 5),
                  ),
                  SliverPadding(padding: EdgeInsets.only(top: 20.h)),
                  SliverToBoxAdapter(
                    child: res.searchView(context, 'search your courses'),
                  ),
                  SliverToBoxAdapter(child: slidersView(context, state)),
                  SliverToBoxAdapter(child: menuView()),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 18.h,
                      horizontal: 0.w,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 1.6,
                          ),
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                            
                            
                            );
                          },
                          child: courseGrid(state.courseItem[index]),
                        );
                      }, childCount: state.courseItem.length),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
