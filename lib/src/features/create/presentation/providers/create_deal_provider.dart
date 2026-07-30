import 'dart:io';
import 'package:cartmates/src/imports/imports.dart';
import '../../domain/entities/create_deal_draft.dart';
import '../../data/repositories/create_deal_repository_impl.dart';
import '../../../deals/domain/entities/same_product_deal_detail.dart';

class CreateDealState {
  final CreateDealDraft draft;
  final bool isLoading;
  final String? error;
  final SameProductDealDetail? createdDeal;

  CreateDealState({
    CreateDealDraft? draft,
    this.isLoading = false,
    this.error,
    this.createdDeal,
  }) : draft = draft ?? CreateDealDraft();

  CreateDealState copyWith({
    CreateDealDraft? draft,
    bool? isLoading,
    String? error,
    bool clearError = false,
    SameProductDealDetail? Function()? createdDeal,
  }) {
    return CreateDealState(
      draft: draft ?? this.draft,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error,
      createdDeal: createdDeal != null ? createdDeal() : this.createdDeal,
    );
  }
}

class CreateDealController extends StateNotifier<CreateDealState> {
  final CreateDealRepositoryImpl _repository;

  CreateDealController({CreateDealRepositoryImpl? repository})
      : _repository = repository ?? CreateDealRepositoryImpl(),
        super(CreateDealState());

  void updateName(String name) {
    state = state.copyWith(draft: state.draft.copyWith(name: name));
  }

  void updateSourceUrl(String url) {
    state = state.copyWith(draft: state.draft.copyWith(sourceUrl: url));
  }

  void updateOriginalPrice(double price) {
    state = state.copyWith(draft: state.draft.copyWith(originalPrice: price));
  }

  void updateQtyGoal(int qty) {
    state = state.copyWith(draft: state.draft.copyWith(qtyGoal: qty));
  }

  void updateDeadline(DateTime deadline) {
    state = state.copyWith(draft: state.draft.copyWith(deadline: deadline));
  }

  void updatePickupLocation(String location) {
    state =
        state.copyWith(draft: state.draft.copyWith(pickupLocation: location));
  }

  void updateDescription(String description) {
    state =
        state.copyWith(draft: state.draft.copyWith(description: description));
  }

  void updateImage(File? file) {
    state = state.copyWith(draft: state.draft.copyWith(imageFile: () => file));
  }

  void addCategory(String category) {
    if (category.trim().isEmpty) return;
    final current = List<String>.from(state.draft.categories);
    if (!current.contains(category.trim())) {
      current.add(category.trim());
      state = state.copyWith(draft: state.draft.copyWith(categories: current));
    }
  }

  void removeCategory(String category) {
    final current = List<String>.from(state.draft.categories);
    current.remove(category);
    state = state.copyWith(draft: state.draft.copyWith(categories: current));
  }

  void addTier() {
    final current = List<CreateDealTierDraft>.from(state.draft.pricingTiers);
    if (current.isEmpty) {
      current.add(const CreateDealTierDraft(minQty: 1, price: 0));
    } else {
      final lastMinQty = current.last.minQty;
      final nextMinQty = lastMinQty < 10 ? lastMinQty + 5 : lastMinQty + 10;
      current.add(CreateDealTierDraft(minQty: nextMinQty, price: 0));
    }
    state = state.copyWith(draft: state.draft.copyWith(pricingTiers: current));
  }

  void removeTier(int index) {
    final current = List<CreateDealTierDraft>.from(state.draft.pricingTiers);
    if (current.length > 1 && index >= 0 && index < current.length) {
      current.removeAt(index);
      state =
          state.copyWith(draft: state.draft.copyWith(pricingTiers: current));
    }
  }

  void updateTier(int index, {int? minQty, double? price}) {
    final current = List<CreateDealTierDraft>.from(state.draft.pricingTiers);
    if (index >= 0 && index < current.length) {
      current[index] = current[index].copyWith(minQty: minQty, price: price);
      state =
          state.copyWith(draft: state.draft.copyWith(pricingTiers: current));
    }
  }

  void initializeTiers() {
    if (state.draft.pricingTiers.isEmpty) {
      state = state.copyWith(
        draft: state.draft.copyWith(
          pricingTiers: const [CreateDealTierDraft(minQty: 1, price: 0)],
        ),
      );
    }
  }

  void reset() {
    state = CreateDealState();
  }

  Future<void> submit() async {
    if (!state.draft.isValid) return;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _repository.createSameProductDeal(state.draft);
      state = state.copyWith(isLoading: false, createdDeal: () => result);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final createDealRepositoryProvider = Provider<CreateDealRepositoryImpl>((ref) {
  return CreateDealRepositoryImpl();
});

final createDealProvider =
    StateNotifierProvider<CreateDealController, CreateDealState>((ref) {
  return CreateDealController(
    repository: ref.watch(createDealRepositoryProvider),
  );
});
