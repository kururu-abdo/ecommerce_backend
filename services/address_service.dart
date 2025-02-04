import 'dart:math';



class AddressService {
  factory AddressService() => _instance;
  AddressService._internal();
  static final AddressService _instance = AddressService._internal();

  // final Map<String, List<Address>> _userAddresses = {};

  String _generateId() => Random().nextInt(100000).toString();

  // Get addresses for a user
  /*
  List<Address> getAddresses(String userId) {
    return _userAddresses[userId] ?? [];
  }*/
/*
  // Add a new address
  Address addAddress(Address address) {
    final id = _generateId();
    final newAddress = Address(
      id: 1,
      userId: address.userId,
      street: address.street,
      city: address.city,
      state: address.state,
      zipCode: address.zipCode,
      country: address.country,
    );
    _userAddresses.putIfAbsent(address.userId!, () => []).add(newAddress);
    return newAddress;
  }

  // Update an existing address
  Address? updateAddress(String userId, String addressId, Address updatedAddress) {
    final addresses = _userAddresses[userId];
    if (addresses == null) return null;

    final index = addresses.indexWhere((address) => address.id == addressId);
    if (index == -1) return null;

    addresses[index] = updatedAddress;
    return updatedAddress;
  }

  // Delete an address
  bool deleteAddress(String userId, String addressId) {
    final addresses = _userAddresses[userId];
    if (addresses == null) return false;

    return addresses.remove((address) => address.id == addressId)  ;
  }

*/
}
