<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $email = $_POST["email"];

  // Kết nối đến cơ sở dữ liệu
  // ...

  // Kiểm tra xem email có tồn tại trong cơ sở dữ liệu không
  // ...

  // Nếu email tồn tại, gửi email khôi phục mật khẩu cho người dùng
  // ...
  echo "Một email khôi phục mật khẩu đã được gửi đến địa chỉ email của bạn.";
  // Chuyển hướng về trang đăng nhập sau 2 giây
  header("refresh:2;url=index.php"); 
  }
?>