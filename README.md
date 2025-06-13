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

To test if API is working please use following command:

```bash
make test-api
```

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

Отлично, вот полное дополнение к твоему `README.md`, полностью на **английском языке**, с разметкой, в едином формате:

---

## 📘 API Usage Guide

This section describes how to manually test all required features using `curl`. You can also use Postman or any other REST client.

### ✅ 1. Create a New User

`POST /api/users`

```bash
curl -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "John",
    "last_name": "Doe",
    "phone": "+48123123123",
    "emails": ["john@example.com", "doe@example.com"]
  }'
```

or 

```bash
make test-create-user
```

Expected response: `201 Created` with user and emails JSON.

---

### 🔍 2. Retrieve All Users

`GET /api/users`

```bash
curl http://localhost:8000/api/users
```

or

```bash
make test-list-users
```

Expected response: list of users and their emails.

---

### 🔎 3. Retrieve Single User

`GET /api/users/{id}`

```bash
curl http://localhost:8000/api/users/1
```

Replace `1` with the actual user ID.

---

### ✏️ 4. Update User

`PUT /api/users/{id}`

```bash
curl -X PUT http://localhost:8000/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "Jane",
    "last_name": "Smith",
    "phone": "+48123456789",
    "emails": ["jane@example.com"]
  }'
```

Expected response: updated user data.

---

### ❌ 5. Delete User

`DELETE /api/users/{id}`

```bash
curl -X DELETE http://localhost:8000/api/users/1
```

Expected response: `204 No Content`.

---

### 📧 6. Send Welcome Email to All User Emails

`POST /api/users/{id}/send-welcome`

```bash
curl -X POST http://localhost:8000/api/users/1/send-welcome
```

or

```bash
make test-send-welcome-mail
```

Expected response:

```json
{
  "message": "Emails sent"
}
```

You can view sent emails via Mailpit:

👉 [http://localhost:8025](http://localhost:8025)

---
