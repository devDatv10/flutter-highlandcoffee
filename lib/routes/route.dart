import 'package:get/get_navigation/get_navigation.dart';
import 'package:highlandcoffeeapp/components/pages/payment_result_page.dart';
import 'package:highlandcoffeeapp/widgets/choose_login_type_page%20.dart';
import 'package:highlandcoffeeapp/components/pages/order_page.dart';
import 'package:highlandcoffeeapp/components/pages/favorite_product_page.dart';
import 'package:highlandcoffeeapp/components/pages/list_product_page.dart';
import 'package:highlandcoffeeapp/components/pages/product_popular_page.dart';
import 'package:highlandcoffeeapp/pages/admin/admin_page.dart';
import 'package:highlandcoffeeapp/pages/auth/auth_user_page.dart';
import 'package:highlandcoffeeapp/pages/cart/cart_page.dart';
import 'package:highlandcoffeeapp/pages/home/home_page.dart';
import 'package:highlandcoffeeapp/pages/introduce/introduce_page1.dart';
import 'package:highlandcoffeeapp/pages/introduce/introduce_page2.dart';
import 'package:highlandcoffeeapp/pages/user/page/my_order_page.dart';
import 'package:highlandcoffeeapp/pages/user/page/update_user_profille.dart';
import 'package:highlandcoffeeapp/pages/welcome/welcome_page.dart';

List<GetPage> getPages = [
  GetPage(name: '/welcome_page', page: () => const WelcomePage()),
  GetPage(name: '/introduce_page1', page: () => const IntroducePage1()),
  GetPage(name: '/introduce_page2', page: () => const IntroducePage2()),
  GetPage(name: '/choose_login_type_page', page: () => ChooseLoginTypePage()),
  GetPage(name: '/auth_page', page: () => const AuthUserPage()),
  GetPage(name: '/home_page', page: () => const HomePage()),
  GetPage(name: '/list_product_page', page:() => const ListProductPage()),
  GetPage(name: '/product_popular_page', page:() => const ProductPopularPage()),
  GetPage(name: '/favorite_product_page', page:() => const FavoriteProductPage()),
  GetPage(name: '/cart_page', page:() => const CartPage()),
  GetPage(name: '/bill_page', page:() => const BillPage()),
  GetPage(name: '/admin_page', page:() => const AdminPage()),
  GetPage(name: '/update_user_profile_page', page:() => const UpdateUserProfilePage()),
  GetPage(name: '/my_order_page', page:() => const MyOrderPage()),
  GetPage(name: '/payment_result_page', page:() => const PaymentResultPage()),
];
