import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/api_client.dart';
import '../../../data/models/emi_plan.dart';
import '../../../data/models/product.dart';
import '../../../data/models/product_variant.dart';
import '../../../data/repositories/product_repository.dart';

// ─── Repository provider ──────────────────────────────────────────────────────

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(); // datasource selected by ProductRepository._defaultDataSource()
});

// ─── Marketplace list state ───────────────────────────────────────────────────

enum MarketplaceStatus { initial, loading, success, error, empty }

class MarketplaceState {
  final MarketplaceStatus status;
  final List<Product> products;
  final String? errorMessage;

  const MarketplaceState({
    this.status = MarketplaceStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  MarketplaceState copyWith({
    MarketplaceStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return MarketplaceState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == MarketplaceStatus.loading;
  bool get hasError => status == MarketplaceStatus.error;
  bool get isEmpty => status == MarketplaceStatus.empty;
  bool get isSuccess => status == MarketplaceStatus.success;
}

class MarketplaceNotifier extends StateNotifier<MarketplaceState> {
  final ProductRepository _repository;

  MarketplaceNotifier(this._repository) : super(const MarketplaceState());

  Future<void> loadProducts() async {
    state = state.copyWith(status: MarketplaceStatus.loading);
    try {
      final products = await _repository.getProducts();
      if (products.isEmpty) {
        state = state.copyWith(status: MarketplaceStatus.empty, products: []);
      } else {
        state = state.copyWith(
          status: MarketplaceStatus.success,
          products: products,
        );
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        status: MarketplaceStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: MarketplaceStatus.error,
        errorMessage: 'Unable to load products. Please try again.',
      );
    }
  }
}

final marketplaceProvider =
    StateNotifierProvider<MarketplaceNotifier, MarketplaceState>((ref) {
  return MarketplaceNotifier(ref.watch(productRepositoryProvider));
});

// ─── Product detail state ─────────────────────────────────────────────────────

class ProductDetailState {
  final MarketplaceStatus status;
  final Product? product;
  final ProductVariant? selectedVariant;
  final EmiPlan? selectedEmiPlan;
  final String? errorMessage;

  const ProductDetailState({
    this.status = MarketplaceStatus.initial,
    this.product,
    this.selectedVariant,
    this.selectedEmiPlan,
    this.errorMessage,
  });

  ProductDetailState copyWith({
    MarketplaceStatus? status,
    Product? product,
    ProductVariant? selectedVariant,
    EmiPlan? selectedEmiPlan,
    bool clearVariant = false,
    bool clearEmiPlan = false,
    String? errorMessage,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedVariant:
          clearVariant ? null : (selectedVariant ?? this.selectedVariant),
      selectedEmiPlan:
          clearEmiPlan ? null : (selectedEmiPlan ?? this.selectedEmiPlan),
      errorMessage: errorMessage,
    );
  }

  bool get isLoading => status == MarketplaceStatus.loading;
  bool get hasError => status == MarketplaceStatus.error;
  bool get isSuccess => status == MarketplaceStatus.success;

  /// Proceed CTA is enabled only when both variant and EMI plan are chosen.
  bool get canProceed => selectedVariant != null && selectedEmiPlan != null;
}

class ProductDetailNotifier
    extends StateNotifier<ProductDetailState> {
  final ProductRepository _repository;

  ProductDetailNotifier(this._repository)
      : super(const ProductDetailState());

  Future<void> loadProduct(String slug) async {
    state = state.copyWith(
      status: MarketplaceStatus.loading,
      clearVariant: true,
      clearEmiPlan: true,
    );
    try {
      final product = await _repository.getProductBySlug(slug);

      if (product == null) {
        state = state.copyWith(
          status: MarketplaceStatus.error,
          errorMessage: 'Product not found',
        );
        return;
      }

      // Auto-select first in-stock variant
      final firstVariant = product.variants.isNotEmpty
          ? product.variants.firstWhere(
              (v) => v.inStock,
              orElse: () => product.variants.first,
            )
          : null;

      state = state.copyWith(
        status: MarketplaceStatus.success,
        product: product,
        selectedVariant: firstVariant,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        status: MarketplaceStatus.error,
        errorMessage: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: MarketplaceStatus.error,
        errorMessage: 'Unable to load product. Please try again.',
      );
    }
  }

  void selectVariant(ProductVariant variant) {
    // Changing variant clears EMI plan (price may differ)
    state = state.copyWith(selectedVariant: variant, clearEmiPlan: true);
  }

  void selectEmiPlan(EmiPlan plan) {
    state = state.copyWith(selectedEmiPlan: plan);
  }

  void clearEmiPlan() {
    state = state.copyWith(clearEmiPlan: true);
  }
}

final productDetailProvider = StateNotifierProvider.family<
    ProductDetailNotifier, ProductDetailState, String>((ref, slug) {
  return ProductDetailNotifier(ref.watch(productRepositoryProvider));
});
