# Makefile — запуск Laravel-проекта в один шаг

PROJECT_NAME=laravel-crud

# Команда по умолчанию
.DEFAULT_GOAL := all

all: env up install migrate test info

env:
	@if [ ! -f .env ]; then \
		echo "🔧 Kopiuję .env.docker → .env"; \
		cp .env.docker .env; \
	fi

up:
	@echo "🚀 Buduję i uruchamiam kontenery Docker..."
	docker compose up -d --build

install:
	@echo "📦 Instaluję zależności przez Composer..."
	docker compose exec laravel.test composer install

migrate:
	@echo "🧩 Wykonuję migracje..."
	docker compose exec laravel.test php artisan migrate

test:
	@echo "✅ Uruchamiam testy jednostkowe..."
	docker compose exec laravel.test ./vendor/bin/phpunit || true

info:
	@echo ""
	@echo "🎉 Projekt gotowy!"
	@echo "🌐 API działa na: http://localhost:8000"
	@echo "📬 Mailhog dostępny pod: http://localhost:8025"
	@echo ""
