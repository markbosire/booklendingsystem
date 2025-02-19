# 📖 Book Lending System - Setup Guide

![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Rails](https://img.shields.io/badge/Rails-CC0000?style=for-the-badge&logo=rubyonrails&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white)
![Minitest](https://img.shields.io/badge/Minitest-5B92E5?style=for-the-badge&logo=ruby&logoColor=white)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge)

---

## 📌 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Clone the Repository](#clone-the-repository)
3. [Install Ruby and Rails 8](#install-ruby-and-rails-8)
4. [Install Bundler](#install-bundler)
5. [Install Dependencies](#install-dependencies)
6. [Set Up the Database](#set-up-the-database)
7. [Start the Rails Server](#start-the-rails-server)
8. [Run Tests](#run-tests)
9. [Common Issues & Solutions](#common-issues--solutions)
10. [Getting Started](#getting-started)

---

## Prerequisites

Before starting the installation, ensure your system meets these requirements:

- **System Dependencies**:
  - Node.js 
  - Yarn 
  - Git


## **Clone the Repository**
First, clone the existing Ruby on Rails project repository to your local machine.

```bash
git clone https://github.com/markbosire/booklendingsystem
cd booklendingsystem
```

## **Install Ruby and Rails 8**
To install Ruby and Rails 8 on your system, please visit the official documentation for installation instructions:

🔗 [Ruby Installation Documentation](https://www.ruby-lang.org/en/documentation/installation/)
🔗 [Rails 8 Installation](https://guides.rubyonrails.org/install_ruby_on_rails.html)

## **Install Bundler**
Bundler is used to manage Ruby gems. Install it if you don't already have it:

```bash
gem install bundler
```

## **Install Dependencies**
Install all the required gems specified in the `Gemfile`:

```bash
bundle install
```

## **Set Up the Database**
Most Rails projects use a database. You need to set it up and run migrations.

- **Configure the Database**: Check the `config/database.yml` file to ensure the database settings are correct for your environment (development, test, production).

- **Create the Database**:
  ```bash
  rails db:create
  ```

- **Run Migrations**:
  ```bash
  rails db:migrate
  ```

- **Seed the Database** (if necessary):
  ```bash
  rails db:seed
  ```

## **Start the Rails Server**
Once everything is set up, you can start the Rails server:

```bash
rails server
```

By default, the server will run on `http://localhost:3000`.

## **Run Tests**

⚠️ **Note:** System wide tests with `rails test` will not work since capybara tests with Selenium have not been configured in this project you have to specify the test folders as shown below.

```bash
rails test test/models
rails test test/views
rails test test/controllers
```


## Common Issues & Solutions

### Tailwind CSS Not Loading

#### In Virtual Machines
1. **Precompile Assets**:
   ```bash
   rails assets:precompile
   ```

2. **If still not working, try reinstalling node modules**:
   ```bash
   rm -rf node_modules
   yarn install
   ```

#### General Solutions
### Server Not Loading
1. **Binding Server to All Interfaces**:
   ```bash
   rails server -b 0.0.0.0
   ```

2. **Clear Asset Cache**:
   ```bash
   rails assets:clean
   rails assets:clobber
   rails assets:precompile
   ```

### Other Common Issues

1. **Database Connection Errors**:
   ```bash
   rails db:reset
   ```

2. **JavaScript Runtime Issues**:
   ```bash
   yarn install
   yarn build
   yarn build:css
   ```

## Getting Started

After completing the setup, you can log in with the following credentials from the seed data:

- **Email**: user1@example.com
- **Password**: password1

Visit `http://localhost:3000` and use these credentials to access the system.

---

⚠️ For security in production environments, remember to change default credentials and configure proper authentication methods.