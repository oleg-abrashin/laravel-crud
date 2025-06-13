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

	@echo "🌐 Checking HTTP server on localhost:8000..."
	@timeout=60; \
	until curl -sSf http://localhost:8000 >/dev/null 2>&1 || [ $$timeout -eq 0 ]; do \
		echo "🔄 Waiting for HTTP on localhost:8000... ($$timeout)"; \
		sleep 2; \
		timeout=$$((timeout - 2)); \
	done; \
	if [ $$timeout -eq 0 ]; then \
		echo "❌ Timeout waiting for HTTP server"; \
		exit 1; \
	fi
	@echo "✅ HTTP server is up on http://localhost:8000"


migrate:
	@echo "🧩 Running migrations..."
	@./vendor/bin/sail artisan migrate

test:
	@echo "✅ Running tests..."
	@./vendor/bin/sail test || true

info:
	@echo ""
	@echo "🎉 Project is ready!"
	@echo "🌐 API: http://localhost:8000"
	@echo "📬 Mailpit: http://localhost:8025"
	@echo ""
