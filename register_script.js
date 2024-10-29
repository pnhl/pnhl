function validateRegisterForm() {
    var password = document.getElementById("password").value;
    var confirmPassword = document.getElementById("confirm_password").value;
    var passwordError = document.getElementById("password-error");
  
    // Kiểm tra mật khẩu có ít nhất 8 ký tự, 1 chữ thường, 1 chữ hoa, 1 số và 1 ký tự đặc biệt
    var passwordRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
  
    if (!passwordRegex.test(password)) {
      passwordError.textContent = "Mật khẩu phải có ít nhất 8 ký tự, 1 chữ thường, 1 chữ hoa, 1 số và 1 ký tự đặc biệt.";
      return false;
    } else if (password !== confirmPassword) {
      passwordError.textContent = "Mật khẩu và xác nhận mật khẩu không khớp.";
      return false;
    } else {
      passwordError.textContent = "";
      return true;
    }
  }