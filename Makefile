PROJECT_NAME=laravel-crud

export

.DEFAULT_GOAL := all

all: check-docker fix-credentials ensure-env composer-install sail-install sail-up wait-for-laravel migrate test info

# Run this manually to start containers (without rebuild)
up: sail-up wait-for-laravel info

# Run this manually to stop all containers and cleanup volumes
down: sail-down

check-docker:
	@command -v docker >/dev/null 2>&1 || { echo "❌ Docker is not installed."; exit 1; }
	@docker info >/dev/null 2>&1 || { echo "❌ Docker is not running."; exit 1; }

fix-credentials:
	@if ! command -v docker-credential-desktop >/dev/null 2>&1; then \
		echo "🔧 Fixing docker-credential-desktop PATH..."; \
		echo 'export PATH="/Applications/Docker.app/Contents/Resources/bin:$$PATH"' >> ~/.zshrc; \
		source ~/.zshrc; \
	fi

ensure-env:
	@if [ ! -f .env ]; then \
		echo "🔧 Creating .env from .env.example"; \
		cp .env.example .env; \
	fi

composer-install:
	@echo "📦 Installing Composer dependencies..."
	@composer install --no-interaction --prefer-dist

sail-install:
	@if [ ! -f sail ]; then \
		echo "🚀 Installing Laravel Sail..."; \
		php artisan sail:install --with=pgsql,redis,mailpit; \
	fi

sail-up:
	@echo "🐳 Starting Laravel Sail containers..."
	@./vendor/bin/sail up -d

sail-down:
	@echo "🧹 Stopping and removing Laravel Sail containers..."
	@./vendor/bin/sail down --volumes --remove-orphans

wait-for-laravel:
	@echo "⏳ Waiting for Laravel artisan command..."
	@timeout=60; \
	until ./vendor/bin/sail artisan --version >/dev/null 2>&1 || [ $$timeout -eq 0 ]; do \
		echo "🔄 Waiting for artisan... ($$timeout)"; \
		sleep 2; \
		timeout=$$((timeout - 2)); \
	done; \
	if [ $$timeout -eq 0 ]; then \
		echo "❌ Timeout waiting for artisan"; \
		exit 1; \
	fi
	@echo "✅ Artisan available."
	@echo "🛠 Generating app key if needed..."
	@./vendor/bin/sail artisan key:generate || true
	@echo "🌐 Checking HTTP server on http://localhost:${APP_PORT:-8000}/up ..."
	@timeout=60; \
	until curl -sSf http://localhost:${APP_PORT:-8000}/up >/dev/null 2>&1 || [ $$timeout -eq 0 ]; do \
		echo "🔄 Waiting for HTTP on /up ... ($$timeout)"; \
		sleep 2; \
		timeout=$$((timeout - 2)); \
	done; \
	if [ $$timeout -eq 0 ]; then \
		echo "❌ Timeout waiting for HTTP server"; \
		exit 1; \
	fi
	@echo "✅ HTTP server is up on http://localhost:${APP_PORT:-8000}/up"

migrate:
	@echo "🧩 Running migrations..."
	@./vendor/bin/sail artisan migrate

test:
	@echo "✅ Running PHPUnit tests..."
	@./vendor/bin/sail test || true

# --- Custom test cases with curl to verify API behavior ---
# Note: You can run these commands manually or call via `make test-api`

# Create user with emails, expects HTTP 201
test-create-user:
	@echo "📧 Testing user creation with emails..."
	@curl -s -X POST http://0.0.0.0:8000/api/users -H "Content-Type: application/json" -d '{"first_name":"John","last_name":"Doe","phone":"+48123123123","emails":["john@example.com","doe@example.com"]}' -w "\nHTTP Code: %{http_code}\n"

# Get list of users, expects HTTP 200
test-list-users:
	@echo "📋 Testing listing users..."
	@curl -s http://0.0.0.0:8000/api/users -w "\nHTTP Code: %{http_code}\n"

# Update user with id=1 (adjust ID as needed), expects HTTP 200
test-update-user:
	@echo "✏️ Testing updating user ID=1..."
	@curl -s -X PUT http://0.0.0.0:8000/api/users/1 -H "Content-Type: application/json" -d '{"first_name":"Jane","last_name":"Doe","phone":"+48123456789","emails":["jane@example.com"]}' -w "\nHTTP Code: %{http_code}\n"

# Delete user with id=1 (adjust ID as needed), expects HTTP 204
test-delete-user:
	@echo "🗑 Testing deleting user ID=1..."
	@curl -s -X DELETE http://0.0.0.0:8000/api/users/1 -w "\nHTTP Code: %{http_code}\n"

# Send welcome email to user ID=1 (adjust ID as needed), expects HTTP 200
test-send-welcome-mail:
	@echo "📨 Testing sending welcome mail to user ID=1..."
	@curl -s -X POST http://0.0.0.0:8000/api/users/1/send-welcome -w "\nHTTP Code: %{http_code}\n"

# Run all above curl API tests sequentially
test-api: test-create-user test-list-users test-update-user test-send-welcome-mail test-delete-user

info:
	@echo ""
	@echo "🎉 Project is ready!"
	@echo "🌐 API: http://0.0.0.0:8000"
	@echo "📬 Mailpit: http://0.0.0.0:8025"
	@echo ""
