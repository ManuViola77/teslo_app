import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';

import '../../../../shared/shared.dart';

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductFormState(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gender: product.gender,
          description: product.description,
          tags: product.tags.join(', '),
          images: product.images,
        ));

  void onTitleChange(String value) {
    final Title title = Title.dirty(value);
    state = state.copyWith(
      title: title,
      isFormValid:
          Formz.validate([title, state.slug, state.price, state.inStock]),
    );
  }

  void onSlugChange(String value) {
    final Slug slug = Slug.dirty(value);
    state = state.copyWith(
      slug: slug,
      isFormValid:
          Formz.validate([slug, state.title, state.price, state.inStock]),
    );
  }

  void onPriceChange(double value) {
    final Price price = Price.dirty(value);
    state = state.copyWith(
      price: price,
      isFormValid:
          Formz.validate([price, state.title, state.slug, state.inStock]),
    );
  }

  void onStockChange(int value) {
    final Stock inStock = Stock.dirty(value);
    state = state.copyWith(
      inStock: inStock,
      isFormValid: Formz.validate([
        inStock,
        state.title,
        state.slug,
        state.price,
      ]),
    );
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.dirty(''),
    this.slug = const Slug.dirty(''),
    this.price = const Price.dirty(0),
    this.sizes = const [],
    this.gender = 'men',
    this.inStock = const Stock.dirty(0),
    this.description = '',
    this.tags = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductFormState(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
