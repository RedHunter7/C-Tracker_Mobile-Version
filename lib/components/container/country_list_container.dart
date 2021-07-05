import 'package:ctracker/components/card/country_card.dart';
import 'package:ctracker/data/country.dart';
import 'package:ctracker/utility/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryListContainer extends StatefulWidget {
  final double screenWidth;
  final Future<List<Country>> countryCardData;

  CountryListContainer({
    Key? key,
    required this.screenWidth,
    required this.countryCardData,
  }) : super(key: key);

  @override
  _CountryListContainerState createState() => _CountryListContainerState();
}

class _CountryListContainerState extends State<CountryListContainer>
    with AutomaticKeepAliveClientMixin {
  late int gridRowCount;
  late double gridSpace;
  late double searchBarMaxWidth;
  late Future<List<Country>> countryCardData;
  List<Country> countryList = [];
  late bool firstLoad = false;
  late bool onSearch = false;

  late FocusNode searchFocusNode;
  final searchController = TextEditingController();

  late int loadCardIndex = 20;
  List<Country> showCountryList = [];
  final ScrollController scrollController = ScrollController();

  _refreshCountryTab(Future<List<Country>> data, bool isReset) {
    if(isReset == true) {
      loadCardIndex = 20;
      showCountryList.clear();
    }
    setState(() {
      countryCardData = data;
    });
  }

  @override
  void initState() {
    super.initState();
    countryCardData = widget.countryCardData;
    searchFocusNode = FocusNode();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    if (widget.screenWidth >= 1280) {
      searchBarMaxWidth = 800;
      gridRowCount = 3;
      gridSpace = 20;
    } else if (widget.screenWidth >= 768) {
      searchBarMaxWidth = 700;
      gridRowCount = 2;
      gridSpace = 20;
    } else {
      searchBarMaxWidth = 450;
      gridRowCount = 1;
      gridSpace = 20;
    }
    return FutureBuilder<List<Country>>(
      future: countryCardData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ));
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          int startLoad = loadCardIndex - 20;

          if (firstLoad == false) {
            countryList.addAll(snapshot.data!);
            firstLoad = true;
          }

          if (onSearch == false) {
            if (loadCardIndex >= countryList.length)
              loadCardIndex = countryList.length;

            showCountryList
                .addAll(snapshot.data!.sublist(startLoad, loadCardIndex));
          }

          String searchValue = searchController.text;

          super.build(context);
          return RefreshIndicator(
              child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: <Widget>[
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: searchBarMaxWidth),
                        child: TextField(
                          controller: searchController,
                          cursorColor: neutralColor,
                          focusNode: searchFocusNode,
                          style: TextStyle(color: neutralColor),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: neutralColor,
                            ),
                            suffixIcon: searchFocusNode.hasPrimaryFocus
                                ? GestureDetector(
                                    child:
                                        Icon(Icons.close, color: neutralColor),
                                    onTap: () {
                                      searchController.clear();
                                      searchFocusNode.requestFocus();
                                      onSearch = false;
                                      _refreshCountryTab(fetchCountryCardData(''), true);
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: searchFocusNode.hasPrimaryFocus
                                ? secondaryColor
                                : tertiaryColor,
                            hoverColor: secondaryColor,
                            focusColor: secondaryColor,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.none, width: 0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            hintText: 'Search Your Country Name',
                            hintStyle: TextStyle(
                              color: neutralColor,
                            ),
                          ),
                          onTap: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus)
                              currentFocus.unfocus();
                          },
                          onSubmitted: (String value) async {
                            if (value != '') {
                              onSearch = true;
                              Future<List<Country>>
                                  filterCountryCardData() async {
                                final countries = countryList.where((country) {
                                  final countryName =
                                      country.name.toLowerCase();
                                  final searchValue = value.toLowerCase();

                                  return countryName.contains(searchValue);
                                }).toList();
                                return countries;
                              }

                              _refreshCountryTab(filterCountryCardData(), false);
                            }
                          },
                          onChanged: (String value) async {
                            if (value == '') {
                              onSearch = false;
                              _refreshCountryTab(fetchCountryCardData(''), true);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15),
                      Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: gridRowCount,
                            childAspectRatio: 2,
                            mainAxisSpacing: gridSpace,
                            crossAxisSpacing: gridSpace,
                          ),
                          itemCount: onSearch
                              ? snapshot.data!.length
                              : showCountryList.length + 1,
                          itemBuilder: (context, index) {
                            if (index == showCountryList.length) {
                              if (showCountryList.length ==
                                  countryList.length) {
                                return SizedBox(
                                  height: 10,
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.white,
                                ));
                              }
                            } else {
                              return CountryCard(
                                name: snapshot.data![index].name,
                                flag: snapshot.data![index].flag,
                                iso: snapshot.data![index].iso,
                                totalConfirmed:
                                    snapshot.data![index].totalConfirmed,
                                newConfirmed:
                                    snapshot.data![index].newConfirmed,
                                totalRecovered:
                                    snapshot.data![index].totalRecovered,
                                newRecovered:
                                    snapshot.data![index].newRecovered,
                                totalDeath: snapshot.data![index].totalDeath,
                                newDeath: snapshot.data![index].newDeath,
                              );
                            }
                          },
                        ),
                      )
                    ],
                  )),
              onRefresh: () {
                return _refreshCountryTab(fetchCountryCardData(searchValue), false);
              }
            );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Can't load data",
                  style: TextStyle(
                    fontSize: 16,
                    color: neutralColor,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                OutlinedButton(
                  onPressed: () {
                    _refreshCountryTab(fetchCountryCardData(''), true);
                  },
                  child: Text(
                    'Refresh',
                    style: TextStyle(color: neutralColor),
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        );
      },
    );
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        onSearch == false) {
      setState(() {
        loadCardIndex = loadCardIndex + 20;
      });
    }
  }
}
