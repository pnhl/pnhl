<!DOCTYPE html>
<html>
<head>
<title>Đăng nhập</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
  <div class="container">
    <h1>Đăng nhập</h1>
    <form action="login.php" method="post" onsubmit="return validateForm()">
      <label for="username">Tên người dùng:</label>
      <input type="text" id="username" name="username" required>

      <label for="password">Mật khẩu:</label>
      <input type="password" id="password" name="password" required>

      <div id="password-error" class="error"></div>

      <div class="form-options">
        <a href="forgot_password.php">Quên mật khẩu?</a> 
        <a href="register.php">Đăng ký</a> 
      </div>

      <input type="submit" value="Đăng nhập">
    </form>
  </div>

  <script src="script.js"></script>
</body>
</html>