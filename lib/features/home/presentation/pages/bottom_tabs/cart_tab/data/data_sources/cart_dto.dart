import 'package:dartz/dartz.dart';
import 'package:la_mode/core/api/api_consumer.dart';
import 'package:la_mode/core/api/end_points.dart';
import 'package:la_mode/core/error/failure.dart';
import 'package:la_mode/core/error/server_failure.dart';
import 'package:la_mode/core/utils/app_constants.dart';
import 'package:la_mode/features/home/presentation/pages/bottom_tabs/cart_tab/data/models/add_to_cart_model.dart';

import '../models/cart_model.dart';

abstract class CartDto {
  Future<Either<Failures, CartModel>> getCartItems();

  Future<Either<Failures, AddToCartModel>> addItemToCart(String productId);

  Future<Either<Failures, CartModel>> updateItemCountCart(
      String productId, int count);

  Future<Either<Failures, CartModel>> removeItemFromCart(String productId);
}

class RemoteCartDto extends CartDto {
  ApiConsumer apiConsumer;

  RemoteCartDto(this.apiConsumer);

  @override
  Future<Either<Failures, CartModel>> getCartItems() async {
    try {
      var response =
          await apiConsumer.get('${AppConstants.baseUrl}${EndPoints.cart}');

      CartModel cartModel = CartModel.fromJson(response);
      return Right(cartModel);
    } catch (e) {
      return Left(
        ServerFailures(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failures, AddToCartModel>> addItemToCart(
      String productId) async {
    try {
      var response = await apiConsumer
          .post("${AppConstants.baseUrl}${EndPoints.cart}", data: {
        "productId": productId,
      });
      AddToCartModel addToCartModel = AddToCartModel.fromJson(response);
      return Right(addToCartModel);
    } catch (e) {
      return Left(ServerFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, CartModel>> removeItemFromCart(
      String productId) async {
    try {
      var response = await apiConsumer.delete(
        "${AppConstants.baseUrl}${EndPoints.cart}/$productId",
      );
      CartModel cartModel = CartModel.fromJson(response);
      return Right(cartModel);
    } catch (e) {
      return Left(ServerFailures(e.toString()));
    }
  }

  @override
  Future<Either<Failures, CartModel>> updateItemCountCart(
      String productId, int count) async {
    try {
      var response = await apiConsumer.put(
        "${AppConstants.baseUrl}${EndPoints.cart}/$productId",
        data: {
          "count": count,
        },
      );
      CartModel cartModel = CartModel.fromJson(response);
      return Right(cartModel);
    } catch (e) {
      return Left(ServerFailures(e.toString()));
    }
  }
}
