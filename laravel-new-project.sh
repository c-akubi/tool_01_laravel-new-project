#!/bin/bash

# ============================
# Color definitions
# ============================
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
CYAN="\033[36m"
RESET="\033[0m"

log_success() { echo -e "${GREEN}✔ $1${RESET}"; }
log_error()   { echo -e "${RED}✘ $1${RESET}"; }
log_warn()    { echo -e "${YELLOW}⚠ $1${RESET}"; }
log_info()    { echo -e "${CYAN}➡ $1${RESET}"; }

echo "============================================"
echo "🚀 Laravel 12 Breeze Auto Setup Script"
echo "============================================"

#----------------------------------------
# 1. Homebrew
#----------------------------------------
log_info "Checking Homebrew..."
if ! command -v brew >/dev/null 2>&1; then
    log_warn "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        log_error "Homebrew installation failed."
        exit 1
    }
else
    log_success "Homebrew OK"
fi

#----------------------------------------
# 2. PHP Version Check
#----------------------------------------
log_info "Checking PHP..."
PHP_VERSION=$(php -v 2>/dev/null | head -n 1 | awk '{print $2}')

if [[ -z "$PHP_VERSION" ]]; then
    log_error "PHP not found. Please install PHP manually."
    exit 1
fi

REQUIRED="8.2"
log_info "PHP Installed: $PHP_VERSION"
log_info "Laravel 12 を使うなら PHP 8.2+ 推奨"

# バージョン比較
if [[ "$(printf '%s\n' "$REQUIRED" "$PHP_VERSION" | sort -V | head -n1)" != "$REQUIRED" ]]; then
    log_warn "Your PHP version is below recommended ($REQUIRED)."
fi

#----------------------------------------
# 3. Composer
#----------------------------------------
log_info "Checking Composer..."
if ! command -v composer >/dev/null 2>&1; then
    log_warn "Composer not found. Installing..."
    brew install composer || {
        log_error "Composer installation failed."
        exit 1
    }
else
    log_success "Composer OK"
fi

#----------------------------------------
# 4. Node
#----------------------------------------
log_info "Checking Node.js..."
if ! command -v npm >/dev/null 2>&1; then
    log_warn "Node.js not found. Installing..."
    brew install node || {
        log_error "Node installation failed."
        exit 1
    }
else
    log_success "Node.js OK"
fi

#----------------------------------------
# 5. Project Input (JP/EN)
#----------------------------------------
echo ""
echo "1.プロジェクト名 / Project name:"
read PROJECT

echo "2.作成ディレクトリ（絶対パス）/ Install directory (absolute path):"
read DEST

echo ""
echo "3.フロント選択 / Choose frontend:"
echo "  1) Blade"
echo "  2) Vue"
echo "  3) React"
echo "番号を入力 / Enter number (1-3):"
read FRONT_NUM

case $FRONT_NUM in
  1) FRONT="blade" ;;
  2) FRONT="vue" ;;
  3) FRONT="react" ;;
  *) log_error "Invalid selection"; exit 1 ;;
esac

mkdir -p "$DEST"
cd "$DEST"

#----------------------------------------
# 6. Laravel Create (12 明示)
#----------------------------------------
log_info "Creating Laravel 12 project..."
composer create-project --prefer-dist laravel/laravel:^12.0 $PROJECT || {
    log_error "Failed to create Laravel project."
    exit 1
}

cd $PROJECT

#----------------------------------------
# 7. .env.example → .env（念のため）
#----------------------------------------
if [[ ! -f .env ]]; then
    log_info "Copying .env.example → .env ..."
    cp .env.example .env || {
        log_error "Failed to copy .env"
        exit 1
    }
    log_success ".env created"
else
    log_success ".env already exists"
fi

#----------------------------------------
# 8. Breeze Install
#----------------------------------------
log_info "Installing Breeze..."
composer require laravel/breeze --dev
php artisan breeze:install $FRONT

#----------------------------------------
# 9. npm (Vue/React only)
#----------------------------------------
if [[ "$FRONT" == "vue" || "$FRONT" == "react" ]]; then
    log_info "Cleaning node_modules..."
    rm -rf node_modules package-lock.json
    
    log_info "Installing npm dependencies..."
    npm install --legacy-peer-deps

    log_info "Running npm dev..."
    npm run dev
fi

#----------------------------------------
# 10. Update .env
#----------------------------------------
log_info "Updating .env..."

sed -i '' "s/APP_NAME=.*/APP_NAME=\"${PROJECT}\"/" .env
sed -i '' "s|APP_URL=.*|APP_URL=http://localhost:8000|" .env

#----------------------------------------
# 11. Generate APP KEY
#----------------------------------------
log_info "Generating APP_KEY..."
php artisan key:generate

echo ""
echo "============================================"
echo -e "${GREEN} Setup Completed!${RESET}"
echo "📁 Project: $DEST/$PROJECT"
echo "🌐 URL:     http://localhost:8000"
echo "============================================"