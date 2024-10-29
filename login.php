<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $username = $_POST["username"];
  $password = $_POST["password"];

  // Kết nối đến cơ sở dữ liệu (thay thế thông tin cho phù hợp)
  $servername = "sql201.infinityfree.com";
  $dbusername = "if0_37605966";
  $dbpassword = "110906Long";
  $dbname = "if0_37605966_void_db";
  
  $conn = new mysqli($servername, $dbusername, $dbpassword, $dbname);

  // Kiểm tra kết nối
  if ($conn->connect_error) {
    die("Kết nối thất bại: " . $conn->connect_error);
  }

  // Truy vấn cơ sở dữ liệu để kiểm tra thông tin đăng nhập
  $sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
  $result = $conn->query($sql);

  if ($result->num_rows > 0) {
    // Đăng nhập thành công
    echo "Đăng nhập thành công!";
    // Chuyển hướng đến pnhl.id.vn/qq
    header("refresh:2;url=http://pnhl.id.vn/qq"); 
  } else {
    // Đăng nhập thất bại
    echo "Tên người dùng hoặc mật khẩu không đúng.";
  }

  $conn->close();
}
?>