import 'package:cartmates/src/utils/utils.dart';
import 'package:fpdart/fpdart.dart';

class SavedLocalDatasource {
  SavedLocalDatasource._();
  static final SavedLocalDatasource instance = SavedLocalDatasource._();

  final Set<String> _savedIds = {'1', '3', '5'};

  FutureEither<List<Map<String, dynamic>>> getSavedDeals() async {
    return right(
      _mockSavedDeals.where((e) => _savedIds.contains(e['id'])).toList(),
    );
  }

  FutureEither<bool> toggleSave(String dealId) async {
    if (_savedIds.contains(dealId)) {
      _savedIds.remove(dealId);
      return right(false);
    } else {
      _savedIds.add(dealId);
      return right(true);
    }
  }

  FutureEither<bool> isDealSaved(String dealId) async {
    return right(_savedIds.contains(dealId));
  }
}

final List<Map<String, dynamic>> _mockSavedDeals = [
  {
    'id': '1',
    'name': 'Bulk Organic Avocados (Box of 20)',
    'image_url': 'https://picsum.photos/seed/avocado/400/300',
    'current_price': 18.50,
    'original_price': 35.00,
    'qty_current': 12,
    'qty_goal': 15,
    'confirmed_qty': 10,
    'hold_qty': 2,
    'time_remaining': 8100,
    'savings_percentage': 47.1,
  },
  {
    'id': '3',
    'name': 'A4 Sketchbook Bundle (Pack of 10)',
    'image_url': 'https://picsum.photos/seed/sketch/400/300',
    'current_price': 15.00,
    'original_price': 33.00,
    'qty_current': 22,
    'qty_goal': 50,
    'confirmed_qty': 15,
    'hold_qty': 7,
    'time_remaining': 172800,
    'savings_percentage': 54.5,
  },
  {
    'id': '5',
    'name': 'Laundry Pods Mega Pack (120ct)',
    'image_url': 'https://picsum.photos/seed/laundry/400/400',
    'current_price': 21.99,
    'original_price': 39.99,
    'qty_current': 45,
    'qty_goal': 100,
    'confirmed_qty': 30,
    'hold_qty': 15,
    'time_remaining': 172800,
    'savings_percentage': 45.0,
  },
];
