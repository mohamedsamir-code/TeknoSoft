import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:la_mode/config/routes.dart';
import 'package:la_mode/features/home/domain/entities/prduct_entity.dart';
import 'package:la_mode/features/home/presentation/manager/provider/home_cubit.dart';
import 'package:la_mode/features/home/presentation/pages/bottom_tabs/cart_tab/presentation/manager/cart_cubit.dart';
import 'package:la_mode/features/home/presentation/pages/bottom_tabs/cart_tab/presentation/manager/cart_state.dart';
import 'package:la_mode/features/product_details/presentation/manager/product_details_cubit.dart';
import 'package:la_mode/features/product_details/presentation/manager/product_details_state.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:readmore/readmore.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_components.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../home/presentation/pages/bottom_tabs/cart_tab/presentation/manager/payment/payment_cubit.dart';
import '../../../home/presentation/pages/bottom_tabs/wishlist/presentation/manager/wishlist_cubit.dart';
import '../../../home/presentation/pages/bottom_tabs/wishlist/presentation/manager/wishlist_state.dart';
import '../widgets/color_container.dart';
import '../widgets/property_button.dart';
import '../widgets/rating.dart';
import '3d_model_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductDataEntity dataEntity;

  const ProductDetailsScreen({required this.dataEntity, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          ProductDetailsCubit(dataEntity.images!.length),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBarWithBag(
            appBarTitle: "Product Details".tr(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: SizedBox(
                    height: 400,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.sp),
                      ),
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: ProductDetailsCubit.get(context)
                            .currentPageController,
                        onPageChanged: (value) {
                          ProductDetailsCubit.get(context).onPageChanged(value);
                        },
                        itemBuilder: (BuildContext context, int index) =>
                            Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                dataEntity.images![index],
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child:
                                      BlocBuilder<WishlistCubit, WishlistState>(
                                    builder: (context, state) {
                                      if (WishlistCubit.get(context)
                                          .wishlist
                                          .any((element) =>
                                              element.id == dataEntity.id)) {
                                        return CustomInkWell(
                                          onTap: () {
                                            WishlistCubit.get(context)
                                                .removeWish(dataEntity.id!);
                                          },
                                          child: Lottie.asset(
                                            repeat: false,
                                            fit: BoxFit.cover,
                                            "assets/animation/favorite.json",
                                            width: 32.w,
                                            height: 32.h,
                                          ),
                                        );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.w, vertical: 6.h),
                                          child: CustomInkWell(
                                            onTap: () {
                                              WishlistCubit.get(context)
                                                  .addWish(dataEntity.id!);
                                            },
                                            child: Image(
                                              image: const AssetImage(
                                                AppIcons.heart,
                                              ),
                                              color: AppColors.lightColor,
                                              width: 20.w,
                                              height: 20.h,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.transparent,
                                  ),
                                  child: CustomInkWell(
                                    onTap: () {
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: const Model3d(
                                          productName: 'White Sneaker',
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    },
                                    child: Image.asset(
                                      AppIcons.model3D,
                                      width: 25.w,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        itemCount: dataEntity.images!.length,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0.w, vertical: 10.h),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          GestureDetector(
                        onTap: () {
                          ProductDetailsCubit.get(context).onPageChanged(index);
                          ProductDetailsCubit.get(context)
                              .currentPageController
                              .animateToPage(index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.fastLinearToSlowEaseIn);
                        },
                        child: Container(
                          width: ProductDetailsCubit.get(context)
                                      .currentPageIndex ==
                                  index
                              ? 110.w
                              : 110.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: ProductDetailsCubit.get(context)
                                            .currentPageIndex ==
                                        index
                                    ? AppColors.gold
                                    : Colors.white,
                                width: 2.w),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.sp),
                            ),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                dataEntity.images![index],
                              ),
                              fit: BoxFit.cover,
                              opacity: 0.9,
                            ),
                          ),
                        ),
                      ),
                      itemCount: dataEntity.images!.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        width: 5.w,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              dataEntity.title!,
                              style: roboto18W500(),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "\$${dataEntity.priceAfterDiscount ?? dataEntity.price!}",
                              style: roboto18W500(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        "Available in stock".tr(),
                        style: roboto16(
                          color: AppColors.lightColor,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      ///--brand --///
                      Row(
                        children: [
                          Container(
                            width: 52.sp,
                            height: 52.sp,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.gold),
                              borderRadius: BorderRadius.all(
                                Radius.circular(26.sp),
                              ),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    "${dataEntity.brand!.image}"),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: CircleAvatar(
                                backgroundColor: AppColors.gold,
                                radius: 12.sp,
                                child: const Icon(
                                  Icons.add,
                                  color: AppColors.lightColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 203.w,
                                    child: Text(
                                      "${dataEntity.brand!.name}",
                                      style: roboto16W500(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  ViewButton(title: "seller".tr()),
                                ],
                              ),
                              Text(
                                "${dataEntity.brand!.slug}",
                                style: roboto14(
                                  color: AppColors.silverDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.h,
                      ),

                      ///---Description---///
                      CategoryName(title: "Description".tr()),
                      ReadMoreText(
                        dataEntity.description!,
                        trimLines: 3,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Read more'.tr(),
                        trimExpandedText: 'Read less'.tr(),
                        moreStyle: roboto14(
                          color: AppColors.lightColor,
                        ),
                        lessStyle: roboto14(
                          color: AppColors.lightColor,
                        ),
                        style: roboto14(
                          color: AppColors.silverDark,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      ///---Sizes---///
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CategoryName(title: "Available sizes".tr()),
                              Text(
                                "Size guide".tr(),
                                style: roboto14(
                                  weight: FontWeight.w500,
                                  color: AppColors.silverDark,
                                ).copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          SizedBox(
                            height: 45.h,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: ProductDetailsCubit.get(context)
                                    .sizes
                                    .length,
                                itemBuilder: (context, index) {
                                  return PropertyButton(
                                    color: ProductDetailsCubit.get(context)
                                                .sizeSelectedIndex ==
                                            index
                                        ? AppColors.lightColor
                                        : AppColors.lightGray,
                                    text: ProductDetailsCubit.get(context)
                                        .sizes[index],
                                    onTap: () {
                                      ProductDetailsCubit.get(context)
                                          .onSizeTap(index);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      ///---Colors---///
                      CategoryName(title: "Colors".tr()),
                      SizedBox(
                        height: 50.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount:
                              ProductDetailsCubit.get(context).colors.length,
                          itemBuilder: (context, index) {
                            return ColorContainer(
                              onTap: () {
                                ProductDetailsCubit.get(context)
                                    .onColorTap(index);
                              },
                              index: index,
                              color: ProductDetailsCubit.get(context)
                                  .colors[index],
                              colorIndex:
                                  ProductDetailsCubit.get(context).colorIndex,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            width: 5.w,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),

                      ///---Reviews---///
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryName(title: "Rating and reviews".tr()),
                          ViewButton(
                            title: "reviews".tr(),
                            onTap: () {
                              Navigator.pushNamed(context, Routes.review);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "4.0",
                            style: robotoCustomize(
                              fontSize: 35.sp,
                              fontWeigh: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RatingBarIndicator(
                                rating: 4,
                                unratedColor: AppColors.silverM,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.sp,
                                direction: Axis.horizontal,
                              ),
                              Text(
                                "Based on 210 Reviews",
                                style: roboto14(
                                  weight: FontWeight.w400,
                                  color: AppColors.silverDark,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Column(
                        children: [
                          CuRatingBar(
                            value: 4 / 5,
                            text: 'Excellent'.tr(),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CuRatingBar(
                            value: 3 / 5,
                            text: 'Good'.tr(),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CuRatingBar(
                            value: 2 / 5,
                            text: 'Average'.tr(),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CuRatingBar(
                            value: 1 / 5,
                            text: 'Below Average'.tr(),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          CuRatingBar(
                            value: 0 / 5,
                            text: 'Poor'.tr(),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),

                      ///---Match with---///
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategoryName(title: "Match with this".tr()),
                                const ViewALl(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 220.h,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => index == 0
                                    ? SizedBox(
                                        width: 0.w,
                                      )
                                    : SizedBox(
                                        width: 5.w,
                                      ),
                                separatorBuilder: (context, index) =>
                                    ProductCard(
                                      dataEntity: HomeCubit.get(context)
                                          .products[index],
                                    ),
                                itemCount:
                                    HomeCubit.get(context).products.length),
                          ),
                        ],
                      ),

                      ///---Recently Viewed---///
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategoryName(title: "Recently viewed".tr()),
                                const ViewALl(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 220.h,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => index == 0
                                    ? SizedBox(
                                        width: 0.w,
                                      )
                                    : SizedBox(
                                        width: 5.w,
                                      ),
                                separatorBuilder: (context, index) =>
                                    ProductCard(
                                      dataEntity: HomeCubit.get(context)
                                          .products[index],
                                    ),
                                itemCount:
                                    HomeCubit.get(context).products.length),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
            builder: (BuildContext context, CartState state) => Container(
              width: double.infinity,
              height: 80.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.sp),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: CartCubit.get(context)
                        .products
                        .any((product) => product.product!.id == dataEntity.id)
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: MyButton(
                          onPressed: () {
                            PaymentCubit.get(context).getAuthToken(
                              "eman@gmail.com",
                              "01120744802",
                              "eman",
                              "ashraf",
                              "${CartCubit.get(context).totalCartPrice}",
                            );
                          },
                          text: "Buy Now".tr(),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50.h,
                              child: MyButton(
                                onPressed: () {
                                  CartCubit.get(context)
                                      .addItemToCart(dataEntity.id!);
                                },
                                text: "Add To Bag".tr(),
                                textColor: AppColors.lightColor,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 50.h,
                              child: MyButton(
                                onPressed: () {
                                  PaymentCubit.get(context).getAuthToken(
                                    "eman@gmail.com",
                                    "01120744802",
                                    "eman",
                                    "ashraf",
                                    "${CartCubit.get(context).totalCartPrice}",
                                  );
                                },
                                text: "Buy Now".tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          drawer: const MyDrawer(
            userName: '',
            userEmail: '',
          ),
        ),
      ),
    );
  }
}
