<p align="center">
  <a href="https://laravel.com" target="_blank">
    <img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo">
  </a>
</p>

<p align="center">
  <a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
  <a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
  <a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
  <a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

---

## ℹ️ Project Overview

This is a recruitment task that implements a simple RESTful API using **Laravel 12**. It provides CRUD operations for users and their associated email addresses, as well as functionality to send a welcome message.

### ✨ Features

- Create, read, update, and delete users
- Each user can have multiple email addresses
- Ability to send a welcome message ("Welcome user XXX") to all associated email addresses
- RESTful JSON API
- Unit tests included
- Runs in Docker using Laravel Sail
- PostgreSQL and Redis support
- Mail delivery to real email addresses is supported

---

## 🚀 Getting Started

### 1. Requirements

- Docker (running daemon)
- GNU Make
- (Optional) Postman or cURL for API testing

### 2. Launch the project

```bash
git clone https://github.com/oleg-abrashin/laravel-crud.git
cd laravel-crud
make
```

After a few minutes, the application will be available at:

- API: `http://localhost:8000`
- Mailhog (for test emails): `http://localhost:8025`

The `make` command will:

- Check Docker installation and daemon status
- Ensure `.env` file exists
- Automatically fix Docker credential issues (for macOS)
- Build and start all Docker containers
- Ensure compatibility with ARM64 platforms (e.g., Apple M1/M2)
- Wait for database readiness
- Generate `APP_KEY`
- Run `composer install` and database migrations
- Execute unit tests

---

## 🧪 Running Tests

To execute the PHPUnit tests:

```bash
make test
```

---

## 📦 Docker & Infrastructure

All Docker-related files are located in the `.docker/` directory and are orchestrated using `docker-compose.yml`.

Includes:
- Laravel Sail
- PostgreSQL database
- Redis cache
- Xdebug support
- Mailhog for mail inspection
- Custom `Makefile` for full project setup with one command

---

## 📬 Email Delivery

By default, the project is configured to use Mailhog for testing purposes. To use real email sending, update the SMTP settings in your `.env` file.

---

## 🧱 Tech Stack

- Laravel 12
- PHP 8.3
- PostgreSQL
- Redis
- Docker
- Laravel Sail
- PHPUnit
- Mailhog

---

## 👤 Author

**Oleg Abrashin**  
[GitHub Profile](https://github.com/oleg-abrashin)

---

## 📝 License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).