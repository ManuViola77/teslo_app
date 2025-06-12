import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import '../errors/product_errors.dart';
import '../mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products', queryParameters: {
      'limit': limit,
      'offset': offset,
    });

    final List<Product> products = [];

    for (var product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('/products/$id');
      return ProductMapper.jsonToEntity(response.data!);
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw ProductNotFound();
      }
      throw Exception('Error al obtener el producto');
    } catch (e) {
      throw Exception('Error al obtener el producto');
    }
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }

  Future<String> _uploadPhoto(String photoPath) async {
    try {
      final fileName = photoPath.split('/').last;
      final FormData formData = FormData.fromMap({
        'file': MultipartFile.fromFileSync(photoPath, filename: fileName),
      });
      final response = await dio.post('files/product', data: formData);
      return response.data['image'];
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<String>> _uploadPhotos(List<String> photos) async {
    final photosToUpload =
        photos.where((element) => element.contains('/')).toList();
    final photosToIgnore =
        photos.where((element) => !element.contains('/')).toList();

    final List<Future<String>> uploadJob =
        photosToUpload.map(_uploadPhoto).toList();
    final newImages = await Future.wait(uploadJob);

    return [...photosToIgnore, ...newImages];
  }

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      productLike.remove('id');
      final String url =
          (productId == null) ? 'products' : 'products/$productId';

      productLike['images'] = await _uploadPhotos(productLike['images']);

      final response = await dio.request<Map<String, dynamic>>(url,
          data: productLike, options: Options(method: method));

      return ProductMapper.jsonToEntity(response.data!);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<void> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }
}
