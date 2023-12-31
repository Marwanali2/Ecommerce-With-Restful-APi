import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/utils/colors.dart';
import 'package:ecommerce/features/auth/presentation/views/widgets/showSnackBar.dart';
import 'package:ecommerce/features/card/presentation/managers/carts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../managers/favorites_cubit/favorites_cubit.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavouriteViewBody extends StatefulWidget {
  const FavouriteViewBody({Key? key}) : super(key: key);

  @override
  State<FavouriteViewBody> createState() => _FavouriteViewBodyState();
}

class _FavouriteViewBodyState extends State<FavouriteViewBody> {
  @override
  Widget build(BuildContext context) {
    var favoritesCubit = BlocProvider.of<FavoritesCubit>(context);
    var cartsCubit = BlocProvider.of<CartsCubit>(context);
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                child: Row(
                  children: [
                    Text(
                      'Favourites',
                      style: TextStyle(
                        color: color4,
                        fontFamily: 'DancingScript',
                        fontSize: 33.sp,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Container(
                        width: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            5.r,
                          ),
                          color: color9,
                        ),
                        child: Center(
                          child: Text(
                            state is FavoritesLoading
                                ? '... Items'
                                : '${favoritesCubit.favoritesModelList.length} Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DancingScript',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    const CircleAvatar(
                      backgroundColor: color9,
                      child: Icon(Icons.favorite, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: state is FavoritesLoading
                  ? const FavLoadingShimmer()
                  : favoritesCubit.favoritesModelList.isNotEmpty
                      ? favSuccessBody(context, favoritesCubit, cartsCubit)
                      : const NoFavProductsBody(),
            ),
          ],
        );
      },
    );
  }

  SizedBox favSuccessBody(BuildContext context, FavoritesCubit favoritesCubit,
      CartsCubit cartsCubit) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.77,
      child: ListView.builder(
        itemCount: favoritesCubit.favoritesModelList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return FadeInLeft(
            animate: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Slidable(
                endActionPane: ActionPane(
                  extentRatio: 0.7,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        setState(() {
                          favoritesCubit.addOrRemoveFavorites(
                              productId: favoritesCubit
                                  .favoritesModelList[index].id
                                  .toString());
                        });
                        showSnackBar(
                            context, 'Removed Successfully', Colors.red);
                      },
                      spacing: 10,
                      borderRadius: BorderRadius.circular(18),
                      backgroundColor: color11,
                      foregroundColor: Colors.white,
                      icon: Icons.heart_broken,
                      label: 'Un Favourite',
                      autoClose: false,
                    ),
                    BlocBuilder<CartsCubit, CartsState>(
                      builder: (context, state) {
                        return SlidableAction(
                          onPressed: (context) {
                            setState(() {
                              cartsCubit.addOrRemoveCarts(
                                  productId: favoritesCubit
                                      .favoritesModelList[index].id
                                      .toString());
                              cartsCubit.cartsProductsId.contains(favoritesCubit
                                      .favoritesModelList[index].id
                                      .toString())
                                  ? showSnackBar(
                                      context,
                                      "Removed From Carts successfully",
                                      Colors.red)
                                  : showSnackBar(context,
                                      "Added to carts successfully", color9);
                            });
                          },
                          spacing: 10,
                          borderRadius: BorderRadius.circular(18),
                          backgroundColor: color9,
                          foregroundColor: Colors.white,
                          icon: cartsCubit.cartsProductsId.contains(
                                  favoritesCubit.favoritesModelList[index].id
                                      .toString())
                              ? Icons.remove_shopping_cart
                              : Icons.shopping_cart,
                          label: cartsCubit.cartsProductsId.contains(
                                  favoritesCubit.favoritesModelList[index].id
                                      .toString())
                              ? 'Un cart'
                              : 'Add to cart',
                          autoClose: false,
                        );
                      },
                    ),
                  ],
                ),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 180,
                  decoration: BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 17,
                          right: 10,
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              '${favoritesCubit.favoritesModelList[index].image}',
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              height: 155,
                              width: 150,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${favoritesCubit.favoritesModelList[index].image}',
                                  ),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(
                                  20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          favoritesCubit.favoritesModelList[index].discount != 0
                              ? Center(
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ),
                                      color: Colors.greenAccent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Sale -${favoritesCubit.favoritesModelList[index].discount}%',
                                        style: const TextStyle(
                                          color: color4,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DancingScript',
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            child: Text(
                              '${favoritesCubit.favoritesModelList[index].name}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: color10,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          //  const Spacer(),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.5,
                            child: favoritesCubit
                                        .favoritesModelList[index].oldPrice ==
                                    favoritesCubit
                                        .favoritesModelList[index].price
                                ? Text(
                                    '${favoritesCubit.favoritesModelList[index].price}\$',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: color10,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Row(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${favoritesCubit.favoritesModelList[index].oldPrice}\$',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationColor: Colors.red,
                                              decorationThickness: 1.5,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${favoritesCubit.favoritesModelList[index].price}\$',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: color10,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NoFavProductsBody extends StatelessWidget {
  const NoFavProductsBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Lottie.asset(
              'assets/lottie_json_animations/no_favorite_products.json',
              reverse: true,
            ),
          ),
          Text(
            'No Favorites Products',
            style: TextStyle(
              fontSize: 25.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class FavLoadingShimmer extends StatelessWidget {
  const FavLoadingShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.81,
        width: MediaQuery.sizeOf(context).width,
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 150.h,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Shimmer.fromColors(
                    baseColor: color9,
                    highlightColor: color9.withOpacity(
                      0.5,
                    ),
                    period: const Duration(milliseconds: 500),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          18,
                        ),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
