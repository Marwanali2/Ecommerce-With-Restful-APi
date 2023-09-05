import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';
import '../../../../card/presentation/managers/carts_cubit.dart';
import '../../../../favorites/presentation/managers/favorites_cubit/favorites_cubit.dart';
import '../../managers/categories_cubit/categories_cubit.dart';

class CategoryTapProductsListView extends StatefulWidget {
  const CategoryTapProductsListView({Key? key, required this.categoriesCubit, required this.favoritesCubit, required this.cartsCubit}) : super(key: key);

  final CategoriesCubit categoriesCubit;
  final  FavoritesCubit favoritesCubit;
  final  CartsCubit cartsCubit;

  @override
  State<CategoryTapProductsListView> createState() => _CategoryTapProductsListViewState();
}

class _CategoryTapProductsListViewState extends State<CategoryTapProductsListView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 370,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: widget.categoriesCubit.categoryProductsList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 20,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          var cubit = widget.favoritesCubit;
          return Stack(children: [
            Container(
              decoration: const BoxDecoration(
                color: color2,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            widget.favoritesCubit.favoritesProductsId
                                .contains(widget.categoriesCubit
                                .categoryProductsList[index]
                                .id
                                .toString())
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: widget.favoritesCubit
                                .favoritesProductsId
                                .contains(widget.categoriesCubit
                                .categoryProductsList[index]
                                .id
                                .toString())
                                ? Colors.red
                                : color8,
                          ),
                          onPressed: () async {
                            await cubit.addOrRemoveFavorites(
                                productId: widget.categoriesCubit
                                    .categoryProductsList[index].id
                                    .toString());
                            setState(() {});
                          },
                        ),
                        const Spacer(),
                        widget.categoriesCubit.categoryProductsList[index]
                            .discount !=
                            0
                            ? Center(
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(
                                5,
                              ),
                              color: Colors.greenAccent,
                            ),
                            child: Center(
                              child: Text(
                                'Sale -${widget.categoriesCubit.categoryProductsList[index].discount}%',
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
                      ],
                    ),
                    Container(
                      height: 165,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            '${widget.categoriesCubit.categoryProductsList[index].image}',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.categoriesCubit.categoryProductsList[index].name}',
                      style: const TextStyle(
                        color: color6,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        children: [
                          widget.categoriesCubit
                              .categoryProductsList[index]
                              .oldPrice ==
                              widget.categoriesCubit
                                  .categoryProductsList[index]
                                  .price
                              ? Text(
                            '${widget.categoriesCubit.categoryProductsList[index].price}',
                            style: const TextStyle(
                              color: color8,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          )
                              : Row(
                            children: [
                              Text(
                                '${widget.categoriesCubit.categoryProductsList[index].oldPrice}\$',
                                style: const TextStyle(
                                  color: color6,
                                  decoration: TextDecoration
                                      .lineThrough,
                                  decorationColor: Colors.red,
                                  decorationThickness: 1.5,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${widget.categoriesCubit.categoryProductsList[index].price}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 1,
                          ),
                          const Text(
                            '\$',
                            style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () async {
                  await widget.cartsCubit.addOrRemoveCarts(
                      productId: widget.categoriesCubit
                          .categoryProductsList[index].id
                          .toString());
                  setState(
                        () {},
                  );
                },
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: const BoxDecoration(
                    color: color9,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(
                        20,
                      ),
                      topLeft: Radius.circular(
                        20,
                      ),
                    ),
                  ),
                  child: Icon(
                    widget.cartsCubit.cartsProductsId.contains(
                        widget.categoriesCubit
                            .categoryProductsList[index].id
                            .toString())
                        ? Icons.check
                        : Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}