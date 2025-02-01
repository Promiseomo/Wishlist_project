import 'dart:async';
import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final List<Map<String, dynamic>> clothingItems = [
    {'name': 'Stainless Watch', 'price': 45.99, 'image': 'assets/images/pexels-ferarcosn-190819.jpg'},
    {'name': 'Sun Glasses', 'price': 59.99, 'image': 'assets/images/pexels-mota-701877.jpg'},
    {'name': 'Sneakers', 'price': 120.00, 'image': 'assets/images/pexels-melvin-buezo-1253763-2529148(1).jpg'},
    {'name': 'Wrist watch', 'price': 25.99, 'image': 'assets/images/pexels-joey-nguy-n-1056657-2113994.jpg'},
    {'name': 'Casual Jean Jacket', 'price': 89.99, 'image': 'assets/images/pexels-imdennyz-2229712.jpg'},
    {'name': 'Stainless Steel Watches', 'price': 39.99, 'image': 'assets/images/pexels-ferarcosn-190819.jpg'},
    {'name': 'Yellow Bag', 'price': 34.99, 'image': 'assets/images/pexels-godisable-jacob-226636-934673.jpg'},
    {'name': 'Women Brown Leather Jacket', 'price': 150.00, 'image': 'assets/images/pexels-hazardos-887898.jpg'},
    {'name': 'Asos Crop Top For Women', 'price': 19.99, 'image': 'assets/images/pexels-allanfranca-5333043.jpg'},
    {'name': 'Luxury Women Necklace', 'price': 29.99, 'image': 'assets/images/mr_p.jpg'},
    {'name': 'Premium Black Jacket', 'price': 75.00, 'image': 'assets/images/mr_pp.jpg'},
  ];

  List<Map<String, dynamic>> cartItems = [];
  late Timer timer;
  Duration remainingTime = const Duration(hours: 12);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime -= const Duration(seconds: 1);
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      if (!cartItems.contains(item)) {
        cartItems.add(item);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item['name']} added to cart'),
            backgroundColor: const Color(0xFF03DAC6), // Teal
          ),
        );
      }
    });
  }

  void removeFromCart(int index) {
    setState(() {
      final item = cartItems.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} removed from cart'),
          backgroundColor: const Color(0xFF6200EE), // Deep Purple
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Wish List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        actions: [
          // Profile Icon
          IconButton(
            icon: const Icon(Icons.person, color: Colors.black),
            onPressed: () {
              // Navigate to profile page
            },
          ),
          // Cart Icon with Badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.black),
                onPressed: () {
                  // Navigate to cart page
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cartItems.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: const TabBar(
                labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
                unselectedLabelColor: Colors.grey,
                labelColor: Color(0xFF6200EE), // Deep Purple
                indicatorColor: Color(0xFF6200EE), // Deep Purple
                tabs: [
                  Tab(text: "All Items"),
                  Tab(text: "Cart"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // All Items Tab
                  ListView.builder(
                    itemCount: clothingItems.length,
                    itemBuilder: (context, index) {
                      final item = clothingItems[index];
                      final isInCart = cartItems.contains(item);
                      return _buildItemCard(item, isInCart);
                    },
                  ),
                  // Cart Tab
                  cartItems.isEmpty
                      ? const Center(
                          child: Text(
                            'Your cart is empty.',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return _buildItemCard(item, true);
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, bool isInCart) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(item['image']),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '\$${item['price'].toString()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      const Text(
                        'Flash Sales',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6200EE), // Deep Purple
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          formatDuration(remainingTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          isInCart ? Icons.shopping_cart : Icons.add_shopping_cart,
                          color: isInCart ? const Color(0xFF03DAC6) : Colors.grey, // Teal
                        ),
                        onPressed: () {
                          setState(() {
                            if (isInCart) {
                              cartItems.remove(item);
                            } else {
                              addToCart(item);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}