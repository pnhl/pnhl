<!DOCTYPE html>
<html>
<head>
<title>Đăng ký</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
  <div class="container">
    <h1>Đăng ký</h1>
    <form action="register_process.php" method="post" onsubmit="return validateRegisterForm()">
      <label for="username">Tên người dùng:</label>
      <input type="text" id="username" name="username" required>

      <label for="password">Mật khẩu:</label>
      <input type="password" id="password" name="password" required>

      <label for="confirm_password">Xác nhận mật khẩu:</label>
      <input type="password" id="confirm_password" name="confirm_password" required>

      <div id="password-error" class="error"></div>

      <input type="submit" value="Đăng ký">
    </form>
  </div>

  <script src="register_script.js"></script> </body>
</html>