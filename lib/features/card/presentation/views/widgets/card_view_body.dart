import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/widgets/custom_error_widget.dart';
import 'package:ecommerce/features/card/presentation/managers/carts_cubit.dart';
import 'package:ecommerce/features/card/presentation/views/widgets/checkout_view.dart';
import 'package:ecommerce/features/favorites/presentation/managers/favorites_cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../../core/widgets/show_snack_bar.dart';
import 'package:dotted_line/dotted_line.dart';

class CardViewBody extends StatefulWidget {
  const CardViewBody({Key? key}) : super(key: key);

  // static  int productCounter=0;
  @override
  State<CardViewBody> createState() => _CardViewBodyState();
}

class _CardViewBodyState extends State<CardViewBody> {
  @override
  Widget build(BuildContext context) {
    var cartsCubit = BlocProvider.of<CartsCubit>(context);
    var favoritesCubit = BlocProvider.of<FavoritesCubit>(context);

    return BlocConsumer<CartsCubit, CartsState>(
      listener: (context, state) {
        if (state is CartsFailure || state is AddOrRemoveCartFailure) {
          showSnackBar(
              context: context,
              label: 'No Internet Connection',
              backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        if (state is CartsSuccess || state is AddOrRemoveCartSuccess) {
          return Column(
            children: [
              CardAppBar(cartsCubit: cartsCubit),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.63,
                  child: cartsCubit.cartsList.isNotEmpty
                      ? ListView.builder(
                          itemCount: cartsCubit.cartsList.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return FadeInRight(
                              animate: true,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Slidable(
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      Container(
                                        height: 180.w,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.45,
                                        decoration: BoxDecoration(
                                          color: color9,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  cartsCubit.cartItems[index]
                                                      .quantity++;
                                                  CartsCubit.total += cartsCubit
                                                      .cartsList[index].price!;
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: color2,
                                                size: 45,
                                              ),
                                            ),
                                            Text(
                                              cartsCubit.cartItems[index]
                                                          .quantity >
                                                      1
                                                  ? '${cartsCubit.cartItems[index].quantity}'
                                                  : '1',
                                              //'test',
                                              style: TextStyle(
                                                color: color2,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  if (cartsCubit
                                                          .cartItems[index]
                                                          .quantity >
                                                      1) {
                                                    cartsCubit.cartItems[index]
                                                        .quantity--;
                                                    CartsCubit.total -=
                                                        cartsCubit
                                                            .cartsList[index]
                                                            .price!;
                                                  }
                                                  if (cartsCubit
                                                          .cartItems[index]
                                                          .quantity ==
                                                      1) {
                                                    showSnackBar(
                                                      context: context,
                                                      label:
                                                          'Choose at least one item',
                                                      backgroundColor:
                                                          Colors.red,
                                                    );
                                                  }
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.remove,
                                                color: color2,
                                                size: 45,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  endActionPane: ActionPane(
                                    extentRatio: 0.7,
                                    motion: const DrawerMotion(),
                                    children: [
                                      BlocBuilder<FavoritesCubit,
                                          FavoritesState>(
                                        builder: (context, state) {
                                          return SlidableAction(
                                            onPressed: (context) {
                                              setState(() {
                                                favoritesCubit
                                                    .addOrRemoveFavorites(
                                                        productId: cartsCubit
                                                            .cartsList[index].id
                                                            .toString());
                                              });
                                              favoritesCubit.favoritesProductsId
                                                      .contains(cartsCubit
                                                          .cartsList[index].id
                                                          .toString())
                                                  ? showSnackBar(
                                                      context: context,
                                                      label:
                                                          "Removed From Favourites successfully",
                                                      backgroundColor:
                                                          Colors.red)
                                                  : showSnackBar(
                                                      context: context,
                                                      label:
                                                          "Added to Favourites successfully",
                                                      backgroundColor: color9);
                                            },
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            backgroundColor: color11,
                                            foregroundColor: Colors.white,
                                            icon: favoritesCubit
                                                    .favoritesProductsId
                                                    .contains(cartsCubit
                                                        .cartsList[index].id
                                                        .toString())
                                                ? Icons.heart_broken
                                                : Icons.favorite,
                                            label: favoritesCubit
                                                    .favoritesProductsId
                                                    .contains(cartsCubit
                                                        .cartsList[index].id
                                                        .toString())
                                                ? 'Un Favourite'
                                                : 'Favourite',
                                            autoClose: false,
                                          );
                                        },
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            cartsCubit.addOrRemoveCarts(
                                                productId: cartsCubit
                                                    .cartsList[index].id
                                                    .toString());
                                          });
                                          showSnackBar(
                                              context: context,
                                              label:
                                                  "Removed From Carts successfully",
                                              backgroundColor: Colors.red);
                                        },
                                        borderRadius: BorderRadius.circular(18),
                                        backgroundColor: color9,
                                        foregroundColor: Colors.white,
                                        icon: Icons.remove_shopping_cart,
                                        label: 'Un Cart',
                                        autoClose: false,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 180.h,
                                    decoration: BoxDecoration(
                                      color: color2,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                            left: 17.w,
                                            right: 10.w,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '${cartsCubit.cartsList[index].image}',
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Container(
                                                height: 140.h,
                                                width: 135.w,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      '${cartsCubit.cartsList[index].image}',
                                                    ),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            cartsCubit.cartsList[index]
                                                        .discount !=
                                                    0
                                                ? Center(
                                                    child: Container(
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          5,
                                                        ),
                                                        color:
                                                            Colors.greenAccent,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'Sale -${cartsCubit.cartsList[index].discount}%',
                                                          style: TextStyle(
                                                            color: color4,
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'DancingScript',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.5,
                                              child: Text(
                                                '${cartsCubit.cartsList[index].name}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: color10,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                            //  const Spacer(),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.5,
                                              child: cartsCubit.cartsList[index]
                                                          .oldPrice ==
                                                      cartsCubit
                                                          .cartsList[index]
                                                          .price
                                                  ? Text(
                                                      '${cartsCubit.cartsList[index].price}\$',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: color10,
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${cartsCubit.cartsList[index].oldPrice}\$',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                decorationColor:
                                                                    Colors.red,
                                                                decorationThickness:
                                                                    1.5,
                                                                fontSize: 13.sp,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Text(
                                                              '${cartsCubit.cartsList[index].price}\$',
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: color10,
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
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
                        )
                      : SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.5,
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.5,
                                child: Lottie.asset(
                                  'assets/lottie_json_animations/no_carts_products.json',
                                  reverse: true,
                                ),
                              ),
                              Text(
                                'No Carts Products',
                                style: TextStyle(
                                  fontSize: 23.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              FadeInLeftBig(
                animate: true,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  decoration: const BoxDecoration(
                    color: color2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        const DottedLine(
                          dashColor: Colors.black45,
                          dashLength: 10,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Total Cost',
                              style: TextStyle(
                                fontSize: 18,
                                color: color4,
                              ),
                            ),
                            const Spacer(),
                            BlocBuilder<CartsCubit, CartsState>(
                              builder: (context, state) {
                                return Text(
                                  '\$ ${CartsCubit.total}',
                                  style: const TextStyle(
                                      color: color1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutView(),
                                ));
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              color9,
                            ),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.sizeOf(context).width * 0.35,
                                vertical: 10,
                              ),
                            ),
                          ),
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is CartsFailure || state is AddOrRemoveCartFailure) {
          return Column(
            children: [
              // enjoyBar(context, text: 'Cards'),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cards',
                        style: TextStyle(
                          color: color4,
                          //fontFamily: 'DancingScript',
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            color: color9,
                          ),
                          child: Center(
                            child: Text(
                              state is CartsLoading
                                  ? 'No Connection'
                                  : '${cartsCubit.cartsList.length} Items',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DancingScript',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const CircleAvatar(
                        backgroundColor: color9,
                        child: Icon(
                          Icons.shopping_cart,
                          color: color2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Center(child: CustomErrorWidget()),
            ],
          );
        } else {
          return Column(
            children: [
              //   enjoyBar(context, text: 'Cards'),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cards',
                        style: TextStyle(
                          color: color4,
                          //fontFamily: 'DancingScript',
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(),
                      Center(
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            color: color9,
                          ),
                          child: const Center(
                            child: Text(
                              '... Items',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
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
                        child: Icon(
                          Icons.shopping_cart,
                          color: color2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
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
              ),
            ],
          );
        }
      },
    );
  }
}

class CardAppBar extends StatelessWidget {
  const CardAppBar({
    super.key,
    required this.cartsCubit,
  });

  final CartsCubit cartsCubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Cards',
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
                    5,
                  ),
                  color: color9,
                ),
                child: Center(
                  child: Text(
                    '${cartsCubit.cartsList.length} Items',
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
              child: Icon(
                Icons.shopping_cart,
                color: color2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
