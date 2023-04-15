import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../blocs/bloc.dart';
import '../../configs/config.dart';
import '../../configs/routes.dart';
import '../../models/model.dart';
import '../../repository/location_repository.dart';
import '../../utils/translate.dart';
import '../../widgets/sections/seaction_a.dart';
import '../../widgets/sections/seaction_b.dart';
import '../../widgets/sections/seaction_carousel.dart';
import '../../widgets/sections/seaction_d.dart';
import '../../widgets/sections/seaction_e.dart';
import '../../widgets/sections/seaction_g.dart';
import '../product_screen/product_screen.dart';
import 'item_card.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

Map<String, dynamic> products = {};
Map<String, dynamic> bestSeller = {};
List<String> newArrivals = [];
List<String> specialOffers = [];

// class Home3 extends StatelessWidget {
//   const Home3({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen()
//     );
//   }
// }

class Home3 extends StatefulWidget {
  const Home3({Key? key}) : super(key: key);

  @override
  _Home3State createState() => _Home3State();
}

class _Home3State extends State<Home3> {
  bool showLogo = true;
  TextEditingController textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;
  late StreamSubscription _submitSubscription;
  late StreamSubscription _reviewSubscription;

  ///On search
  void _onSearch() {
    Navigator.pushNamed(context, Routes.searchHistory, arguments: _image);
  }

  Future<void> getProducts() async {
    // final String response = await rootBundle.loadString('assets/products.json');
    // final data = await json.decode(response);
    // setState(() {
    //   products = data;
    // });
  }

  Map<String, dynamic> getProduct(String productId) {
    Map<String, dynamic> product = {};
    product['images_count'] = 5;
    product['image'] =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/2012_Toyota_Camry_%28ASV50R%29_Altise_sedan_%282014-09-06%29.jpg/260px-2012_Toyota_Camry_%28ASV50R%29_Altise_sedan_%282014-09-06%29.jpg';
    product['product_id'] = '11';
    product['has_color'] = true;
    product['has_size'] = true;
    product['sub_category'] = 1;
    product['description'] = {'الخامة': 'صوف', 'الفئة': 'شتوي'};
    product['colors'] = [
      {'name': 'بنفسجي', 'color': '0xff001fff'},
      {'name': 'اسود', 'color': '0xff000000'}
    ];
    product['sizes'] = ['sm', 'l', 'xl', 'xxl'];
    product['seller_name'] = 'ameen mamoon';
    product['name'] = 'سيارة ياباني كورلا 2022';
    product['price'] = 4554.54;
    product['stars'] = 4;
    product['seller'] = 4521;
    product['stock'] = 32;
    return product;
  }

  String _getImage(String imageID) {
    return 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/2012_Toyota_Camry_%28ASV50R%29_Altise_sedan_%282014-09-06%29.jpg/260px-2012_Toyota_Camry_%28ASV50R%29_Altise_sedan_%282014-09-06%29.jpg';
  }

  void _getBestSeller() {
    bestSeller["image"] = _getImage('');
    bestSeller["product_id"] = '1556';
    bestSeller["name"] = 'fdgvdf ';
    bestSeller["price"] = r'170 $';
  }

  void _getSpecialOffers() {
    specialOffers.add('1');
    specialOffers.add('2');
    specialOffers.add('3');
    specialOffers.add('4');
    specialOffers.add('5');
  }

  void _getNewArrivals() async {
    newArrivals.add('1');
    newArrivals.add('2');
    newArrivals.add('3');
    newArrivals.add('4');
    newArrivals.add('5');
  }

  @override
  void initState() {
    super.initState();
    bestSeller = {};
    newArrivals = [];
    specialOffers = [];

    // WidgetsBinding.instance?.addPostFrameCallback((_) async {
    // });
    _getNewArrivals();
    _getBestSeller();
    _getSpecialOffers();
    AppBloc.homeCubit.onLoad();
    Application.currentCountry = LocationRepository.loadCountry();
    _submitSubscription = AppBloc.submitCubit.stream.listen((state) {
      if (state is Submitted) {
        AppBloc.homeCubit.onLoad();
      }
    });
    _reviewSubscription = AppBloc.reviewCubit.stream.listen((state) {
      if (state is ReviewByIdSuccess && state.productId != null) {
        AppBloc.homeCubit.onLoad();
      }
    });
  }

  @override
  void dispose() {
    _submitSubscription.cancel();
    _reviewSubscription.cancel();
    super.dispose();
  }

  ///Refresh
  Future<void> _onRefresh() async {
    await AppBloc.homeCubit.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) getProducts();

    var images = [
      "assets/banner_1.jpeg",
      "assets/banner_2.jpeg",
      "assets/banner_3.jpeg",
      "assets/banner_4.jpeg",
    ];

    final product = getProduct('');
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedOpacity(
                      opacity: showLogo ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 100),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                          children: <TextSpan>[
                            TextSpan(
                                text: "alsindbad",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF9E9E9E))),
                            TextSpan(
                              text: ".CO",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                      ) // Image.asset('assets/Beheshti.png', width: 150.0),
                      ),
                )
              ],
            ),
          ),
          toolbarHeight: 100,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
          List<HomeSectionModel>? homeSections;
          // List<CategoryModel>? categories;
          // List<LocationModel>? popularLocations;
          // List<ProductModel>? recentProducts;

          if (state is HomeSuccess) {
            homeSections = state.list;
            // popularLocations = state.popularLocations;
            // recentProducts = state.recentProducts;
          }
          return AnimationLimiter(
              child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 70,
                    child: TextButton(
                      onPressed: _onSearch,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    Translate.of(context).translate(
                                      'search',
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .button!
                                        .copyWith(
                                            color: Theme.of(context)
                                                .appBarTheme
                                                .foregroundColor),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 4, right: 4),
                                  child: VerticalDivider(),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      _image = await _imagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      if (_image != null) {
                                        Uint8List bytes =
                                            await _image!.readAsBytes();
                                        // String bs4str =
                                        //     base64Encode(bytes);
                                        // Map<String, dynamic>
                                        //     params = {
                                        //   "externalId":
                                        //       "externalId",
                                        //   "fileName": _image!.path
                                        //       .split('/')
                                        //       .last,
                                        //   "extension":
                                        //       path.extension(
                                        //           _image!.path),
                                        //   "uploadType":
                                        //       UploadType.product,
                                        //   "size": bytes
                                        //       .elementSizeInBytes,
                                        //   "data": bs4str,
                                        // };
                                        _onSearch();
                                        // UtilOther.buildFilterParams(
                                        //     FilterModel(
                                        //         byImage: params));
                                      }
                                    } catch (e) {}
                                  },
                                  icon: const Icon(
                                    Icons.camera_enhance,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                ),
                items: images.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(7)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: -10.0,
                                blurRadius: 10.0,
                                offset: Offset(0.0, 10.0),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.asset(i, fit: BoxFit.cover),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              if (homeSections != null)
                for (var item in homeSections) ...[
                  if (item.sectionType == HomeSectionType.sectionD)
                    SectionD(data: item)
                ],

              Container(
                height: 250,
                color: const Color(0xffE6123D),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount:
                        specialOffers.isNotEmpty ? specialOffers.length + 1 : 5,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: Padding(
                            padding: EdgeInsets.only(
                                right: 5,
                                left: index == specialOffers.length ? 30 : 5),
                            child: index == 0
                                ? Image.asset(
                                    "assets/banner.png",
                                    width: 150,
                                  )
                                : SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: GestureDetector(
                                      onTap: () {
                                        _showProductScreen(
                                            context, specialOffers[index - 1]);
                                      },
                                      child: Container(
                                        width: 165,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                index - 1 == 0 ? 5 : 1),
                                            topLeft: Radius.circular(
                                                index == specialOffers.length
                                                    ? 5
                                                    : 1),
                                            bottomLeft: Radius.circular(
                                                index == specialOffers.length
                                                    ? 5
                                                    : 1),
                                            bottomRight: Radius.circular(
                                                index - 1 == 0 ? 5 : 1),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 0,
                                              blurRadius: 10,
                                              offset: const Offset(0,
                                                  10), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: specialOffers.isNotEmpty
                                            ? product['image'] != null
                                                ? Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: getItemCard(
                                                        product["image"],
                                                        product["name"],
                                                        product["price"]))
                                                : SizedBox(
                                                    width: 165.0,
                                                    height: 250.0,
                                                    child: Shimmer.fromColors(
                                                        baseColor: Colors.white,
                                                        highlightColor: Colors
                                                            .grey.shade100,
                                                        child: Container(
                                                          width: 500.0,
                                                          height: 500.0,
                                                          color: Colors.white,
                                                        )),
                                                  )
                                            : SizedBox(
                                                width: 165.0,
                                                height: 250.0,
                                                child: Shimmer.fromColors(
                                                    baseColor: Colors.white,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      width: 165.0,
                                                      height: 250.0,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                      ),
                                    )),
                                  )),
                      );
                    }),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: const [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("العروض الاسبوعية",
                                style: TextStyle(
                                    fontFamily: 'Beheshti',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.black)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.abc,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    WeeklyOffersWidget(),
                  ],
                ),
              ),
              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              //   child: SizedBox(
              //     height: 300,
              //     child: MarketSectionsWidget(),
              //   ),
              // ),
              // LayoutBuilder(builder: (context, constraints) {
              //   return SizedBox(
              //     height: constraints.maxHeight,
              //     child: SuccessPartnersWidget(),
              //   );
              // }),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: const [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("الباعة المميزون",
                                style: TextStyle(
                                    fontFamily: 'Beheshti',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.black)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.abc,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    FeaturedSellersWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: const [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("اقسام مميزة",
                                style: TextStyle(
                                    fontFamily: 'Beheshti',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.black)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.abc,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    FeaturedCategoriesWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: FeaturedProductWidgetH(),
              ),
              Container(
                height: 250,
                color: const Color(0x5E9E9E9E),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    itemCount:
                        specialOffers.isNotEmpty ? specialOffers.length + 1 : 5,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: Padding(
                            padding: EdgeInsets.only(
                                right: 5,
                                left: index == specialOffers.length ? 30 : 5),
                            child: index == 0
                                ? Image.asset(
                                    "assets/banner.png",
                                    width: 150,
                                  )
                                : SlideAnimation(
                                    horizontalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: GestureDetector(
                                      onTap: () {
                                        _showProductScreen(
                                            context, specialOffers[index - 1]);
                                      },
                                      child: Container(
                                        width: 165,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                index - 1 == 0 ? 5 : 1),
                                            topLeft: Radius.circular(
                                                index == specialOffers.length
                                                    ? 5
                                                    : 1),
                                            bottomLeft: Radius.circular(
                                                index == specialOffers.length
                                                    ? 5
                                                    : 1),
                                            bottomRight: Radius.circular(
                                                index - 1 == 0 ? 5 : 1),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 0,
                                              blurRadius: 10,
                                              offset: const Offset(0,
                                                  10), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: specialOffers.isNotEmpty
                                            ? product['image'] != null
                                                ? Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: getItemCard(
                                                        product["image"],
                                                        product["name"],
                                                        product["price"]))
                                                : SizedBox(
                                                    width: 165.0,
                                                    height: 250.0,
                                                    child: Shimmer.fromColors(
                                                        baseColor: Colors.white,
                                                        highlightColor: Colors
                                                            .grey.shade100,
                                                        child: Container(
                                                          width: 500.0,
                                                          height: 500.0,
                                                          color: Colors.white,
                                                        )),
                                                  )
                                            : SizedBox(
                                                width: 165.0,
                                                height: 250.0,
                                                child: Shimmer.fromColors(
                                                    baseColor: Colors.white,
                                                    highlightColor:
                                                        Colors.grey.shade100,
                                                    child: Container(
                                                      width: 165.0,
                                                      height: 250.0,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                      ),
                                    )),
                                  )),
                      );
                    }),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Stack(
                        children: const [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text("تخفيضات اقسام الموسم",
                                style: TextStyle(
                                    fontFamily: 'Beheshti',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    color: Colors.black)),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.discount,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                    DiscountedCategoriesWidget(),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                child: FeaturedProductWidgetV(),
              ),

              // Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              //   child: ListView(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(bottom: 20),
              //         child: Stack(
              //           children: const [
              //             Align(
              //               alignment: Alignment.centerRight,
              //               child: Text("پرفروش‌ترین هفته",
              //                   style: TextStyle(
              //                       fontFamily: 'Beheshti',
              //                       fontWeight: FontWeight.w900,
              //                       fontSize: 18,
              //                       color: Colors.black)),
              //             ),
              //             Align(
              //               alignment: Alignment.centerLeft,
              //               child: Icon(
              //                 Icons.abc,
              //                 size: 30,
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           if (bestSeller.isNotEmpty) {
              //             _showProductScreen(context, bestSeller["product_id"]);
              //           }
              //         },
              //         child: Container(
              //           padding: const EdgeInsets.all(15),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius:
              //                 const BorderRadius.all(Radius.circular(6)),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.black.withOpacity(0.05),
              //                 spreadRadius: 0,
              //                 blurRadius: 10,
              //                 offset: const Offset(0, 10),
              //               ),
              //             ],
              //           ),
              //           child: GridView(
              //             shrinkWrap: true,
              //             physics: const NeverScrollableScrollPhysics(),
              //             gridDelegate:
              //                 const SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: 2,
              //               childAspectRatio: 1,
              //               crossAxisSpacing: 30,
              //             ),
              //             children: [
              //               bestSeller.isNotEmpty &&
              //                       (bestSeller["image"] as String).length >
              //                           1000
              //                   ? Image.network(bestSeller["image"])
              //                   : SizedBox(
              //                       width: 75,
              //                       height: 75,
              //                       child: Shimmer.fromColors(
              //                           baseColor: Colors.grey.shade50,
              //                           highlightColor: Colors.grey.shade100,
              //                           child: Container(
              //                             width: 500.0,
              //                             height: 500.0,
              //                             color: Colors.white,
              //                           )),
              //                     ),
              //               Stack(
              //                 children: [
              //                   bestSeller.isNotEmpty
              //                       ? Text(bestSeller["name"],
              //                           style: const TextStyle(
              //                               fontFamily: 'Beheshti',
              //                               fontWeight: FontWeight.bold,
              //                               fontSize: 15,
              //                               color: Colors.black))
              //                       : SizedBox(
              //                           width: 125,
              //                           height: 30,
              //                           child: Shimmer.fromColors(
              //                               baseColor: Colors.grey.shade50,
              //                               highlightColor:
              //                                   Colors.grey.shade100,
              //                               child: Container(
              //                                 width: 500.0,
              //                                 height: 500.0,
              //                                 color: Colors.white,
              //                               )),
              //                         ),
              //                   bestSeller.isNotEmpty
              //                       ? Align(
              //                           alignment: Alignment.bottomLeft,
              //                           child: SizedBox(
              //                             height: 23,
              //                             child: ListView(
              //                               physics:
              //                                   const NeverScrollableScrollPhysics(),
              //                               shrinkWrap: true,
              //                               scrollDirection: Axis.horizontal,
              //                               children: [
              //                                 Text(bestSeller["price"],
              //                                     style: const TextStyle(
              //                                         fontFamily: 'Beheshti',
              //                                         fontWeight:
              //                                             FontWeight.normal,
              //                                         fontSize: 18,
              //                                         color: Colors.black)),
              //                                 const Text("تومان",
              //                                     style: TextStyle(
              //                                         fontFamily: 'Beheshti',
              //                                         fontWeight:
              //                                             FontWeight.bold,
              //                                         fontSize: 10,
              //                                         color: Colors.black)),
              //                               ],
              //                             ),
              //                           ),
              //                         )
              //                       : Container(),
              //                   bestSeller.isNotEmpty
              //                       ? const Align(
              //                           alignment: Alignment.bottomRight,
              //                           child: Icon(
              //                             CupertinoIcons.cart_badge_plus,
              //                             size: 22,
              //                             color: Color(0xFF207D4C),
              //                           ))
              //                       : Container()
              //                 ],
              //               )
              //             ],
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 20),
              //   child: ListView(
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.only(
              //             bottom: 20, right: 25, left: 25),
              //         child: Stack(
              //           children: const [
              //             Align(
              //               alignment: Alignment.centerRight,
              //               child: Text("کالاهای جدید",
              //                   style: TextStyle(
              //                       fontFamily: 'Beheshti',
              //                       fontWeight: FontWeight.w900,
              //                       fontSize: 18,
              //                       color: Colors.black)),
              //             ),
              //             Align(
              //               alignment: Alignment.centerLeft,
              //               child: Icon(
              //                 Icons.access_alarm,
              //                 size: 30,
              //               ),
              //             )
              //           ],
              //         ),
              //       ),
              //       SizedBox(
              //         height: 250,
              //         child: ListView.builder(
              //             scrollDirection: Axis.horizontal,
              //             physics: const BouncingScrollPhysics(),
              //             padding: const EdgeInsets.symmetric(vertical: 20),
              //             itemCount:
              //                 newArrivals.isNotEmpty ? newArrivals.length : 4,
              //             itemBuilder: (context, index) {
              //               return AnimationConfiguration.staggeredList(
              //                   position: index,
              //                   duration: const Duration(milliseconds: 375),
              //                   child: Padding(
              //                     padding: EdgeInsets.only(
              //                         right: index == 0 ? 25 : 5,
              //                         left: index == specialOffers.length - 1
              //                             ? 25
              //                             : 5),
              //                     child: SlideAnimation(
              //                         horizontalOffset: 50.0,
              //                         child: FadeInAnimation(
              //                           child: GestureDetector(
              //                               onTap: () {
              //                                 if (newArrivals.isNotEmpty) {
              //                                   _showProductScreen(context,
              //                                       newArrivals[index]);
              //                                 }
              //                               },
              //                               child: Container(
              //                                   width: 165,
              //                                   decoration: BoxDecoration(
              //                                     color: Colors.white,
              //                                     borderRadius:
              //                                         const BorderRadius.all(
              //                                             Radius.circular(5)),
              //                                     boxShadow: [
              //                                       BoxShadow(
              //                                         color: Colors.black
              //                                             .withOpacity(0.05),
              //                                         spreadRadius: 0,
              //                                         blurRadius: 10,
              //                                         offset: const Offset(0,
              //                                             10), // changes position of shadow
              //                                       ),
              //                                     ],
              //                                   ),
              //                                   child: newArrivals.isNotEmpty &&
              //                                           product['image'] != null
              //                                       ? Container(
              //                                           padding:
              //                                               EdgeInsets.all(10),
              //                                           child: getItemCard(
              //                                               product["image"],
              //                                               product["name"],
              //                                               product["price"]))
              //                                       : SizedBox(
              //                                           width: 165.0,
              //                                           height: 250.0,
              //                                           child:
              //                                               Shimmer.fromColors(
              //                                                   baseColor:
              //                                                       Colors
              //                                                           .white,
              //                                                   highlightColor:
              //                                                       Colors.grey
              //                                                           .shade100,
              //                                                   child:
              //                                                       Container(
              //                                                     width: 500.0,
              //                                                     height: 500.0,
              //                                                     color: Colors
              //                                                         .white,
              //                                                   )),
              //                                         ))),
              //                         )),
              //                   ));
              //             }),
              //       )
              //     ],
              //   ),
              // ),

              // if (homeSections != null)
              //   for (var item in homeSections) ...[
              //     if (item.sectionType == HomeSectionType.sectionD)
              //       SectionD(data: item)
              //     else if (item.sectionType == HomeSectionType.sectionA)
              //       SectionA(data: item)
              //     else if (item.sectionType == HomeSectionType.sectionB)
              //       SectionB(data: item)
              //     else if (item.sectionType == HomeSectionType.sectionG)
              //       SectionG(data: item)
              //     else if (item.sectionType == HomeSectionType.sectionCarousel)
              //       SectionCarousel(data: item)
              //     else if (item.sectionType == HomeSectionType.sectionE)
              //       SectionE(data: item)
              //     // else if (item.sectionType == HomeSectionType.sectionSmallCarousel)
              //     //   SectionSmallCarousel(data: item),
              //   ],
              // Container(
              //   constraints: BoxConstraints(
              //       maxWidth: MediaQuery.of(context).size.width,
              //       maxHeight: 300),
              //   child: WebViewScreen(),
              // )
            ],
          ));
        }));
  }

  void _showProductScreen(BuildContext context, String id) {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => const ProductScreen(id: 2, categoryId: 4)));
  }
}

class WebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // الكود HTML و CSS الذي تريد تنفيذه
    String htmlCode = '''
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body {
            background-color: #f0f0f0;
            text-align: center;
            font-family: Arial, sans-serif;
          }
          h1 {
            color: #333;
          }
        </style>
      </head>
      <body>
        <h1>مرحبًا بك في WebView</h1>
      </body>
      </html>
    ''';

    return Scaffold(
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          webViewController.loadUrl(Uri.dataFromString(htmlCode,
                  mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
              .toString());
        },
      ),
    );
  }
}

class WeeklyOffersWidget extends StatelessWidget {
  final List<Offer> offers = [
    Offer(
      id: 1,
      name: 'عرض 1',
      imageUrl: 'https://via.placeholder.com/150',
      oldPrice: 200,
      newPrice: 150,
    ),
    Offer(
      id: 2,
      name: 'عرض 2',
      imageUrl: 'https://via.placeholder.com/150',
      oldPrice: 300,
      newPrice: 250,
    ),
    Offer(
      id: 3,
      name: 'عرض 3',
      imageUrl: 'https://via.placeholder.com/150',
      oldPrice: 300,
      newPrice: 250,
    ),
    Offer(
      id: 4,
      name: 'عرض 4',
      imageUrl: 'https://via.placeholder.com/150',
      oldPrice: 300,
      newPrice: 250,
    ),
    // يمكنك إضافة المزيد من العروض هنا
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return OfferCard(offer: offer);
        },
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      // width: 150,
      constraints: BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.network(
                offer.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${offer.newPrice} ر.س',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${offer.oldPrice} ر.س',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Offer {
  final int id;
  final String name;
  final String imageUrl;
  final double oldPrice;
  final double newPrice;

  Offer({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.oldPrice,
    required this.newPrice,
  });
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

class FeaturedCategoriesWidget extends StatelessWidget {
  final List<Category> categories = [
    Category(
      id: 1,
      name: 'القسم 1',
      imageUrl: 'https://via.placeholder.com/200',
    ),
    Category(
      id: 2,
      name: 'القسم 2',
      imageUrl: 'https://via.placeholder.com/200',
    ),
    Category(
      id: 3,
      name: 'القسم 3',
      imageUrl: 'https://via.placeholder.com/200',
    ),
    Category(
      id: 4,
      name: 'القسم 4',
      imageUrl: 'https://via.placeholder.com/200',
    ),
    // يمكنك إضافة المزيد من الأقسام هنا
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(category: category);
      },
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              category.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final int id;
  final String name;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////

class DiscountedCategoriesWidget extends StatelessWidget {
  final List<DiscountedCategory> categories = [
    DiscountedCategory(
      id: 1,
      name: 'القسم 1',
      imageUrl: 'https://via.placeholder.com/200',
      discountPercentage: 10,
    ),
    DiscountedCategory(
      id: 2,
      name: 'القسم 2',
      imageUrl: 'https://via.placeholder.com/200',
      discountPercentage: 20,
    ),
    DiscountedCategory(
      id: 3,
      name: 'القسم 3',
      imageUrl: 'https://via.placeholder.com/200',
      discountPercentage: 15,
    ),
    DiscountedCategory(
      id: 4,
      name: 'القسم 4',
      imageUrl: 'https://via.placeholder.com/200',
      discountPercentage: 8,
    ),
    // يمكنك إضافة المزيد من الأقسام هنا
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return DiscountedCategoryCard(category: category);
      },
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }
}

class DiscountedCategoryCard extends StatelessWidget {
  final DiscountedCategory category;

  const DiscountedCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              category.imageUrl,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${category.discountPercentage} % تخفيض',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiscountedCategory {
  final int id;
  final String name;
  final String imageUrl;
  final int discountPercentage;

  DiscountedCategory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.discountPercentage,
  });
}

//////////////////////////////////////////////////////////////////////////////////////////////

class FeaturedProductWidgetH extends StatelessWidget {
  final FeaturedProduct featuredProduct = FeaturedProduct(
    id: 1,
    name: 'منتج مميز',
    description: 'هذا المنتج مميز ويوفر لك جودة عالية وسعر مناسب.',
    imageUrl: 'https://via.placeholder.com/300',
    price: 100.0,
    isSponsored: true,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FeaturedProductCardH(product: featuredProduct),
    );
  }
}

class FeaturedProductCardH extends StatelessWidget {
  final FeaturedProduct product;

  const FeaturedProductCardH({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (product.isSponsored)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'ممول',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      product.description,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedProductWidgetV extends StatelessWidget {
  final FeaturedProduct featuredProduct = FeaturedProduct(
    id: 1,
    name: 'منتج مميز',
    description: 'هذا المنتج مميز ويوفر لك جودة عالية وسعر مناسب.',
    imageUrl: 'https://via.placeholder.com/300',
    price: 100.0,
    isSponsored: true,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FeaturedProductCardV(product: featuredProduct),
    );
  }
}

class FeaturedProductCardV extends StatelessWidget {
  final FeaturedProduct product;

  const FeaturedProductCardV({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            ),
            if (product.isSponsored)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'ممول',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      product.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      product.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedProduct {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final bool isSponsored;

  FeaturedProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.isSponsored,
  });
}

/////////////////////////////////////////////////////////////////////////////////////////

class FeaturedSellersWidget extends StatelessWidget {
  final List<Seller> featuredSellers = [
    Seller(
      id: 1,
      name: 'بائع متميز 1',
      imageUrl: 'https://via.placeholder.com/150',
      rating: 4.5,
    ),
    Seller(
      id: 2,
      name: 'بائع متميز 2',
      imageUrl: 'https://via.placeholder.com/150',
      rating: 4.7,
    ),
    Seller(
      id: 3,
      name: 'بائع متميز 3',
      imageUrl: 'https://via.placeholder.com/150',
      rating: 4.9,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: featuredSellers.length,
        itemBuilder: (context, index) {
          return SellerCard(seller: featuredSellers[index]);
        },
      ),
    );
  }
}

class SellerCard extends StatelessWidget {
  final Seller seller;

  const SellerCard({required this.seller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 110,
      width: 270,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(seller.imageUrl),
            radius: 40,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seller.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              RatingBarIndicator(
                rating: seller.rating,
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Seller {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;

  Seller({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
  });
}

//////////////////////////////////////////////////////////////////////////////////////////////////

class MarketSection {
  final int id;
  final String title;
  final String imageUrl;

  MarketSection(
      {required this.id, required this.title, required this.imageUrl});
}

class MarketSectionsWidget extends StatelessWidget {
  final List<MarketSection> marketSections = [
    MarketSection(
      id: 1,
      title: 'الأزياء',
      imageUrl: 'https://via.placeholder.com/100x100',
    ),
    MarketSection(
      id: 2,
      title: 'الإلكترونيات',
      imageUrl: 'https://via.placeholder.com/100x100',
    ),
    MarketSection(
      id: 3,
      title: 'الكتب',
      imageUrl: 'https://via.placeholder.com/100x100',
    ),
    // إضافة المزيد من الأقسام هنا
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: marketSections.length,
      itemBuilder: (context, index) {
        return MarketSectionCard(marketSection: marketSections[index]);
      },
    );
  }
}

class MarketSectionCard extends StatelessWidget {
  final MarketSection marketSection;

  const MarketSectionCard({Key? key, required this.marketSection})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            marketSection.imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          marketSection.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
