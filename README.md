# Flutter Weather App

## Mô tả dự án

Ứng dụng cho phép người dùng tra cứu thông tin thời tiết hiện tại và dự báo thời tiết cho bất kỳ thành phố nào trên thế giới. Dữ liệu được lấy từ API OpenWeatherMap và hiển thị theo giao diện trực quan với nền màu thay đổi theo điều kiện thời tiết thực tế.

Ứng dụng hỗ trợ đầy đủ các tình huống sử dụng thực tế bao gồm định vị GPS tự động, tìm kiếm theo tên thành phố, lưu cache để dùng khi mất kết nối mạng, và tùy chỉnh đơn vị đo lường theo sở thích người dùng.

---

## Tính năng chính

### Hiển thị thời tiết hiện tại

Ứng dụng hiển thị đầy đủ thông tin thời tiết tại thời điểm hiện tại bao gồm nhiệt độ thực tế và cảm giác nhiệt, icon thời tiết tải trực tiếp từ API, mô tả trạng thái thời tiết, tên thành phố và quốc gia, ngày giờ hiện tại, độ ẩm, tốc độ và hướng gió, áp suất khí quyển, tầm nhìn, độ che phủ mây, thời gian mặt trời mọc và lặn.

### Dự báo thời tiết

Ứng dụng cung cấp dự báo theo hai dạng. Dự báo theo giờ hiển thị 8 giờ tiếp theo với nhiệt độ và xác suất mưa. Dự báo theo ngày hiển thị 5 ngày tiếp theo với nhiệt độ thấp nhất và cao nhất mỗi ngày.

### Tìm kiếm thành phố

Người dùng có thể tìm kiếm thời tiết bằng tên thành phố bất kỳ. Ứng dụng lưu lịch sử 10 lần tìm kiếm gần nhất và hiển thị danh sách các thành phố phổ biến để chọn nhanh.

### Định vị GPS tự động

Khi mở ứng dụng, app tự động xin quyền truy cập vị trí và lấy thời tiết tại vị trí hiện tại của thiết bị. Ứng dụng xử lý đầy đủ các trường hợp từ chối quyền và tự động chuyển sang chế độ tìm kiếm thủ công.

### Hỗ trợ offline

Dữ liệu thời tiết được lưu cache sau mỗi lần tải thành công. Khi thiết bị mất kết nối mạng, ứng dụng tự động hiển thị dữ liệu cache và thông báo rõ ràng cho người dùng. Cache có hiệu lực trong vòng 30 phút.

### Cập nhật dữ liệu

Người dùng có thể kéo màn hình từ trên xuống để tải lại dữ liệu thời tiết mới nhất từ API.

### Cài đặt

Ứng dụng cho phép tùy chỉnh đơn vị nhiệt độ giữa Celsius và Fahrenheit, đơn vị tốc độ gió giữa m/s, km/h và mph, định dạng giờ giữa 12 giờ và 24 giờ. Tất cả cài đặt được lưu lại và áp dụng ngay khi thay đổi.

### Giao diện động

Nền màn hình thay đổi màu gradient theo điều kiện thời tiết thực tế. Nắng hiển thị nền xanh dương, mưa hiển thị nền xám đậm, giông bão hiển thị nền đen xanh, tuyết hiển thị nền trắng nhạt, và ban đêm hiển thị nền tối.

### Xử lý lỗi

Ứng dụng hiển thị thông báo lỗi rõ ràng cho từng tình huống: thành phố không tồn tại, API key không hợp lệ, vượt giới hạn gọi API, mạng không ổn định, và timeout. Tất cả màn hình lỗi có nút thử lại.

---

## Công nghệ sử dụng

| Thành phần | Công nghệ |
|-----------|-----------|
| Framework | Flutter 3.x |
| Ngôn ngữ | Dart 3.x |
| Quản lý state | Provider 6.1.1 |
| Gọi HTTP | http 1.1.0 |
| Định vị GPS | geolocator 10.1.0 |
| Geocoding | geocoding 2.1.1 |
| Lưu trữ local | shared_preferences 2.2.2 |
| Định dạng ngày giờ | intl 0.18.1 |
| Tải ảnh từ mạng | cached_network_image 3.3.0 |
| Bảo mật API key | flutter_dotenv 5.1.0 |
| Kiểm tra mạng | connectivity_plus 5.0.2 |
| Nguồn dữ liệu | OpenWeatherMap API (Free tier) |

---

## Cài đặt API Key

### Bước 1: Đăng ký tài khoản

Truy cập trang web https://openweathermap.org/api và tạo tài khoản miễn phí. Sau khi đăng ký, vào mục API Keys trong trang quản lý tài khoản và sao chép API key được cấp.

Lưu ý: API key mới cần từ 1 đến 2 giờ sau khi đăng ký mới bắt đầu hoạt động.

### Bước 2: Kiểm tra API key

Dán URL sau vào trình duyệt để kiểm tra API key có hoạt động không:

```
https://api.openweathermap.org/data/2.5/weather?q=London&appid=YOUR_API_KEY&units=metric
```

Nếu trả về dữ liệu JSON có trường "name":"London" thì API key đã hoạt động.

### Bước 3: Cấu hình trong dự án

Sao chép file `.env.example` thành file `.env`:

```bash
cp .env.example .env
```

Mở file `.env` và điền API key thật vào:

```
OPENWEATHER_API_KEY=api_key_thật_của_bạn
```

---

## Cấu trúc thư mục

```
lib/
  main.dart                        Điểm khởi đầu ứng dụng, cấu hình Provider
  config/
    api_config.dart                Cấu hình URL và endpoint API
  models/
    weather_model.dart             Lớp dữ liệu thời tiết hiện tại
    forecast_model.dart            Lớp dữ liệu dự báo thời tiết
    location_model.dart            Lớp dữ liệu tọa độ địa lý
  services/
    weather_service.dart           Gọi HTTP đến OpenWeatherMap API
    location_service.dart          Xử lý GPS và geocoding
    storage_service.dart           Lưu trữ cache và cài đặt
    connectivity_service.dart      Kiểm tra trạng thái kết nối mạng
  providers/
    weather_provider.dart          Quản lý toàn bộ state ứng dụng
  screens/
    home_screen.dart               Màn hình chính hiển thị thời tiết
    search_screen.dart             Màn hình tìm kiếm thành phố
    forecast_screen.dart           Màn hình dự báo 5 ngày đầy đủ
    settings_screen.dart           Màn hình cài đặt đơn vị và tùy chọn
  widgets/
    current_weather_card.dart      Card hiển thị thời tiết hiện tại
    hourly_forecast_list.dart      Danh sách dự báo theo giờ cuộn ngang
    daily_forecast_card.dart       Danh sách dự báo theo ngày
    weather_detail_item.dart       Grid chi tiết thời tiết
    loading_shimmer.dart           Hiệu ứng skeleton loading
    error_widget.dart              Màn hình thông báo lỗi
  utils/
    constants.dart                 Hằng số, màu gradient theo thời tiết
    date_formatter.dart            Tiện ích định dạng ngày giờ

test/
  weather_test.dart                Unit tests cho model và chuyển đổi dữ liệu

screenshots/
  01_sunny_clear.png
  02_rainy.png
  03_cloudy.png
  04_night_mode.png
  05_search_screen.png
  06_forecast_screen.png
  07_error_state.png
  08_loading_state.png
```

---

## Link demo

https://transfer.it/t/A5zXqu5llZoY