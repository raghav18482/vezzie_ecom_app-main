class API {
  static const baseUrl = "https://vezzie.in/api";
  static const loginOrRegister = '$baseUrl/user/register';

  static const getProfileData = '$baseUrl/user/profile';
  static const updateProfileData = '$baseUrl/user/profile/update';

  static const termsAndCondtion = "$baseUrl/termcondition";
  static const getBannerImage = "$baseUrl/getbannerimage";
  static const getCatogery = "$baseUrl/category/list";
  static const getproduct = "$baseUrl/product/list";
  static const uplaodeProfilePic = "$baseUrl/user/profile/avatar";
  static const addCart = "$baseUrl/cart/item/add";

  static const removeFromCart = "$baseUrl/cart/item/remove";
  static const getCartInfo = "$baseUrl/cart/info";
  static const cartView = "$baseUrl/cart/view";
  static const addressList = "$baseUrl/address/list";
  static const addNewAddress = "$baseUrl/address/create";
  static const placeOrder = "$baseUrl/order/create";
  static const searchAPI = "$baseUrl/product/search?search=";
  static const coupensAPI = "$baseUrl/coupon/list";
  static const applyCoupens = "$baseUrl/coupon/add/";
  static const removeCoupens = "$baseUrl/coupon/remove/";
  static const appSettings = "$baseUrl/app/setting/view";
  static const myOrderListing = "$baseUrl/order/list";
}
