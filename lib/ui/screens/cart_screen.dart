import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jewellry_shop/states/jew_state.dart';
import 'package:jewellry_shop/states/shared_data.dart';
import 'package:jewellry_shop/ui/widgets/counter_button.dart';
import 'package:jewellry_shop/ui/widgets/empty_wrapper.dart';
import 'package:jewellry_shop/ui_kit/_ui_kit.dart';
import '../../data/_data.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  SharedData get _state => JewState().state;
  List<Jew> get cartItems => _state.cart;
  double taxes = 5.0;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) => Scaffold(
      appBar: _appBar(context),
      body: EmptyWrapper(
        title: "Empty cart",
        isEmpty: cartItems.isEmpty,
        child: _cartListView(context),
      ),
      bottomNavigationBar: cartItems.isEmpty ? const SizedBox.shrink() : _bottomAppBar(context),
    ));
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        "Cart screen",
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  Widget _cartListView(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: cartItems.length,
      itemBuilder: (_, index) {
        final jew = cartItems[index];
        return Dismissible(
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              print('Удаляем');
              _state.onRemoveFromCartTap(jew);
            }
          },
          key: UniqueKey(),
          background: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 25,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const FaIcon(FontAwesomeIcons.trash),
              ),
            ],
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).brightness == Brightness.dark ? DarkThemeColor.primaryDark : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 20),
                Image.asset(jew.image, scale: 10),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jew.name,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "\$${jew.price}",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    CounterButton(
                      onIncrementTap: () => _state.onIncreaseQuantityTap(jew),
                      onDecrementTap: () => _state.onDecreaseQuantityTap(jew),
                      size: const Size(24, 24),
                      padding: 0,
                      label: Text(
                        jew.quantity.toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ),
                    Text(
                      '\$${_state.stickerPrice(jew)}',
                      style: AppTextStyle.h2Style.copyWith(color: LightThemeColor.purple),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) => Container(
        height: 20,
      ),
    );
  }

  Widget _bottomAppBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: BottomAppBar(
          child: SizedBox(
              height: 250,
              child: Container(
                color: Theme.of(context).brightness == Brightness.dark ? DarkThemeColor.primaryDark : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                "\$${_state.subtotal}",
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Taxes",
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                "\$$taxes",
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(thickness: 4.0, height: 30.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              Text(
                                "\$${_state.subtotal + taxes}",
                                style: AppTextStyle.h2Style.copyWith(
                                  color: LightThemeColor.purple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: ElevatedButton(
                              onPressed: _state.onCheckOutTap,
                              child: const Text("Checkout"),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
          ),
      ),
    );
  }
}
