PROJECT_NAME = laravel-crud
APP_PORT     = 8000

export

.DEFAULT_GOAL := all

all: check-docker fix-credentials ensure-env composer-install sail-install sail-up wait-for-laravel migrate test info

# Start everything (without rebuilding)
up: sail-install sail-up wait-for-laravel migrate info

# Stop and clean up
down: sail-down

check-docker:
	@command -v docker >/dev/null 2>&1 || { echo "❌ Docker is not installed."; exit 1; }
	@docker info   >/dev/null 2>&1 || { echo "❌ Docker is not running."; exit 1; }

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
	@echo "⏳ Waiting for Artisan…"
	@timeout=60; \
	until ./vendor/bin/sail artisan --version >/dev/null 2>&1 || [ $$timeout -eq 0 ]; do \
		echo "🔄 Still waiting for Artisan… ($$timeout)"; \
		sleep 2; \
		timeout=$$((timeout - 2)); \
	done; \
	if [ $$timeout -eq 0 ]; then \
		echo "❌ Timed out waiting for Artisan"; exit 1; \
	fi
	@echo "✅ Artisan is ready."
	@echo "🛠 Generating APP_KEY…"
	@./vendor/bin/sail artisan key:generate --force >/dev/null || true

	@echo "🌐 Hitting the health‐check at http://localhost:$(APP_PORT)/up …"
	@timeout=60; \
	until curl -sSf http://localhost:$(APP_PORT)/up >/dev/null 2>&1 || [ $$timeout -eq 0 ]; do \
		echo "🔄 Waiting for HTTP health… ($$timeout)"; \
		sleep 2; \
		timeout=$$((timeout - 2)); \
	done; \
	if [ $$timeout -eq 0 ]; then \
		echo "❌ Timed out waiting for HTTP /up"; exit 1; \
	fi
	@echo "✅ HTTP is up on http://localhost:$(APP_PORT)/up"

migrate:
	@echo "🧩 Running database migrations…"
	@./vendor/bin/sail artisan migrate --force

# Refresh Database before testing
migrate-fresh:
	@echo "🧹 Dropping & re-running all migrations (fresh)…"
	@./vendor/bin/sail artisan migrate:fresh --seed --no-interaction


test:
	@echo "✅ Running PHPUnit tests…"
	@./vendor/bin/sail test || true

info:
	@echo ""
	@echo "🎉 Project is ready!"
	@echo "🌐 API: http://localhost:$(APP_PORT)"
	@echo "📬 Mailpit: http://localhost:8025"
	@echo ""



# --- Custom test cases with curl to verify API behavior ---
# Note: You can run these commands manually or call via `make test-api`

# --- Custom curl API tests ---

test-create-user:
	@echo "📧 Testing user creation with emails..."
	@curl -s -X POST http://0.0.0.0:8000/api/users \
	     -H "Content-Type: application/json" \
	     -d '{"first_name":"John","last_name":"Doe","phone":"+48123123123","emails":["john@example.com","doe@example.com"]}' \
	     -w "\nHTTP Code: %{http_code}\n"

test-list-users:
	@echo "📋 Testing listing users..."
	@curl -s http://0.0.0.0:8000/api/users \
	     -w "\nHTTP Code: %{http_code}\n"

test-update-user:
	@echo "✏️ Testing updating user ID=1..."
	@curl -s -X PUT http://0.0.0.0:8000/api/users/1 \
	     -H "Content-Type: application/json" \
	     -d '{"first_name":"Jane","last_name":"Doe","phone":"+48123456789","emails":["jane@example.com"]}' \
	     -w "\nHTTP Code: %{http_code}\n"

test-send-welcome-mail:
	@echo "📨 Testing sending welcome mail to user ID=1..."
	@curl -s -X POST http://0.0.0.0:8000/api/users/1/send-welcome \
	     -w "\nHTTP Code: %{http_code}\n"

test-delete-user:
	@echo "🗑 Testing deleting user ID=1..."
	@curl -s -X DELETE http://0.0.0.0:8000/api/users/1 \
	     -w "\nHTTP Code: %{http_code}\n"

test-api: migrate-fresh test-create-user test-list-users test-update-user test-send-welcome-mail test-delete-user

