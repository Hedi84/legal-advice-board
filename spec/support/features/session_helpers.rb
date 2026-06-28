module Features
  module SessionHelpers
    def login_as(user, password: "password123")
      visit login_path
      fill_in "Email address", with: user.email_address
      fill_in "Password", with: password
      click_button "Sign in"
    end
  end
end
