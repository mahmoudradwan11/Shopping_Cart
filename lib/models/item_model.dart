class Item {
  final String name;
  final String unit;
  final int price;
  final String image;

  Item(
      {required this.name,
        required this.unit,
        required this.price,
        required this.image});

  Map toJson() {
    return {
      'name': name,
      'unit': unit,
      'price': price,
      'image': image,
    };
  }

  static List<Item> products = [
    Item(
      name: 'Apple',
      unit: 'Kg',
      price: 20,
      image:
      'https://i.pinimg.com/236x/81/d9/05/81d9057cc8621db7946460c27eef59a4.jpg',
    ),
    Item(
        name: 'Mango',
        unit: 'Doz',
        price: 30,
        image:
        'https://i.pinimg.com/236x/8c/35/81/8c3581c767a7089586386bcf61b31424.jpg'),
    Item(
        name: 'Banana',
        unit: 'Doz',
        price: 10,
        image:
        'https://i.pinimg.com/236x/4c/26/2a/4c262a1622ffe6a48d6575aabf17c61a.jpg'),
    Item(
        name: 'Grapes',
        unit: 'Kg',
        price: 8,
        image:
        'https://i.pinimg.com/236x/07/05/07/070507b794ca86e9760dcb2655fc6d6b.jpg'),
    Item(
        name: 'Water Melon',
        unit: 'Kg',
        price: 25,
        image:
        'https://i.pinimg.com/236x/7e/51/40/7e5140ba2af5229aa067fe223951c4de.jpg'),
    Item(
      name: 'Kiwi',
      unit: 'Pc',
      price: 40,
      image:
      'https://i.pinimg.com/236x/26/b7/c2/26b7c28553e70d94f4cbced1c49c58fa.jpg',
    ),
    Item(
        name: 'Orange',
        unit: 'Doz',
        price: 15,
        image:
        'https://i.pinimg.com/236x/81/d9/05/81d9057cc8621db7946460c27eef59a4.jpg'),
    Item(
        name: 'Peach',
        unit: 'Pc',
        price: 8,
        image:
        'https://i.pinimg.com/236x/81/d9/05/81d9057cc8621db7946460c27eef59a4.jpg'),
    Item(
        name: 'Strawberry',
        unit: 'Box',
        price: 12,
        image:
        'https://i.pinimg.com/236x/81/d9/05/81d9057cc8621db7946460c27eef59a4.jpg'),
    Item(
        name: 'Fruit Basket',
        unit: 'Kg',
        price: 55,
        image:
        'https://i.pinimg.com/236x/81/d9/05/81d9057cc8621db7946460c27eef59a4.jpg'),
  ];
}