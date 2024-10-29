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

  // Kiểm tra xem tên người dùng đã tồn tại chưa
  $check_username_sql = "SELECT * FROM users WHERE username='$username'";
  $check_username_result = $conn->query($check_username_sql);

  if ($check_username_result->num_rows > 0) {
    echo "Tên người dùng đã tồn tại.";
  } else {
    // Thêm người dùng mới vào cơ sở dữ liệu
    $insert_sql = "INSERT INTO users (username, password) VALUES ('$username', '$password')";

    if ($conn->query($insert_sql) === TRUE) {
      echo "Đăng ký thành công!";
    } else {
      echo "Lỗi: " . $insert_sql . "<br>" . $conn->error;
    }
  }

  $conn->close();
}
?>