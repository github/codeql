#!/bin/bash

################################################################################
#  PHP CodeQL Autobuilder                                                      #
#  Automatically detects PHP project type and prepares for analysis            #
################################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_info() {
    echo -e "${BLUE}[*]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1"
}

# Get source root (passed by CodeQL)
SOURCE_ROOT="${1:-.}"
TRAP_OUTPUT="${2:-$(pwd)/out}"

log_info "PHP CodeQL Autobuilder"
log_info "Source Root: $SOURCE_ROOT"
log_info "Output: $TRAP_OUTPUT"
echo ""

################################################################################
# Project Type Detection
################################################################################

detect_project_type() {
    local root="$1"

    # Check for WordPress
    if [ -f "$root/wp-config-sample.php" ] || [ -f "$root/wp-config.php" ]; then
        echo "wordpress"
        return 0
    fi

    # Check for Laravel
    if [ -f "$root/artisan" ] && [ -f "$root/composer.json" ]; then
        grep -q "laravel" "$root/composer.json" 2>/dev/null && echo "laravel" && return 0
    fi

    # Check for Symfony
    if [ -f "$root/symfony.lock" ] || [ -f "$root/config/bundles.php" ]; then
        echo "symfony"
        return 0
    fi

    # Check for Drupal
    if [ -f "$root/core/core.info.yml" ] || [ -d "$root/core/modules" ]; then
        echo "drupal"
        return 0
    fi

    # Check for Magento
    if [ -f "$root/composer.json" ] && [ -d "$root/app/code" ]; then
        grep -q "magento" "$root/composer.json" 2>/dev/null && echo "magento" && return 0
    fi

    # Check for Joomla
    if [ -f "$root/configuration.php" ] || [ -d "$root/components" ]; then
        echo "joomla"
        return 0
    fi

    # Check for CodeIgniter
    if [ -f "$root/spark" ] || [ -d "$root/app/Controllers" ]; then
        echo "codeigniter"
        return 0
    fi

    # Check for CakePHP
    if [ -f "$root/bin/cake" ] || [ -f "$root/config/bootstrap.php" ]; then
        echo "cakephp"
        return 0
    fi

    # Check for Yii
    if [ -f "$root/yii" ] || [ -d "$root/models" ]; then
        echo "yii"
        return 0
    fi

    # Check for Zend/Laminas
    if [ -f "$root/composer.json" ]; then
        if grep -q "laminas\|zend" "$root/composer.json" 2>/dev/null; then
            echo "laminas"
            return 0
        fi
    fi

    # Generic PHP project
    echo "generic"
}

get_php_files() {
    local root="$1"

    find "$root" \
        -type f \
        -name "*.php" \
        ! -path "*/vendor/*" \
        ! -path "*/.git/*" \
        ! -path "*/node_modules/*" \
        ! -path "*/build/*" \
        ! -path "*/dist/*" \
        ! -path "*/.cache/*" \
        ! -path "*/tmp/*" \
        2>/dev/null
}

count_php_files() {
    local root="$1"
    get_php_files "$root" | wc -l
}

################################################################################
# Project Analysis
################################################################################

analyze_project() {
    local root="$1"
    local project_type="$2"

    log_info "Analyzing PHP Project"
    echo ""

    # Count PHP files
    local php_count=$(count_php_files "$root")
    log_success "Found $php_count PHP files"

    # Check for composer
    if [ -f "$root/composer.json" ]; then
        log_success "Found composer.json"

        if [ -d "$root/vendor" ]; then
            log_info "Vendor directory exists (dependencies installed)"
        else
            log_warn "Vendor directory not found (dependencies may not be installed)"
        fi
    fi

    # Check for package.json (for build tools)
    if [ -f "$root/package.json" ]; then
        log_success "Found package.json (npm/build tools)"

        if [ -d "$root/node_modules" ]; then
            log_info "Node modules exist"
        fi
    fi

    # Check for configuration files
    if [ -f "$root/config/database.php" ] || [ -f "$root/.env" ]; then
        log_success "Found configuration files"
    fi

    # Check for database directory
    if [ -d "$root/database" ]; then
        log_success "Found database directory"
    fi

    # Check for tests
    if [ -d "$root/tests" ] || [ -d "$root/test" ]; then
        log_success "Found test directory"
    fi

    echo ""
}

################################################################################
# Environment Setup
################################################################################

setup_environment() {
    local root="$1"
    local project_type="$2"

    log_info "Setting up environment for $project_type"

    # Set PHP version if available
    if command -v php &> /dev/null; then
        local php_version=$(php -v | grep -oP 'PHP \K[0-9]+\.[0-9]+' | head -1)
        log_success "PHP version: $php_version"
    fi

    # Install dependencies if needed
    if [ -f "$root/composer.json" ] && [ ! -d "$root/vendor" ]; then
        log_warn "Installing composer dependencies..."
        cd "$root"

        if command -v composer &> /dev/null; then
            composer install --no-interaction --no-scripts 2>/dev/null || \
            log_warn "Could not install composer dependencies (composer not available)"
        else
            log_warn "Composer not found (some code analysis may be incomplete)"
        fi

        cd - > /dev/null
    fi

    echo ""
}

################################################################################
# TRAP Generation
################################################################################

generate_trap() {
    local root="$1"
    local project_type="$2"
    local output="$3"

    log_info "Generating TRAP facts for CodeQL"

    mkdir -p "$output"

    # Count total PHP files for reporting
    local total_files=$(count_php_files "$root")

    log_success "Processing $total_files PHP files"

    # The actual TRAP generation is done by the Rust extractor
    # This function just logs what we're doing

    case "$project_type" in
        wordpress)
            log_info "Analyzing WordPress installation"
            log_info "  - Core files: wp-admin, wp-includes, wp-content"
            log_info "  - Plugins: will be analyzed in wp-content/plugins"
            log_info "  - Themes: will be analyzed in wp-content/themes"
            ;;
        laravel)
            log_info "Analyzing Laravel application"
            log_info "  - App directory: application code"
            log_info "  - Routes: api/web routes"
            log_info "  - Controllers: request handlers"
            ;;
        symfony)
            log_info "Analyzing Symfony application"
            log_info "  - src: application code"
            log_info "  - config: configuration files"
            log_info "  - controllers: request handlers"
            ;;
        *)
            log_info "Analyzing generic PHP project"
            ;;
    esac

    echo ""
}

################################################################################
# Project-Specific Configuration
################################################################################

configure_project() {
    local root="$1"
    local project_type="$2"

    log_info "Configuring for $project_type"

    case "$project_type" in
        wordpress)
            configure_wordpress "$root"
            ;;
        laravel)
            configure_laravel "$root"
            ;;
        symfony)
            configure_symfony "$root"
            ;;
        drupal)
            configure_drupal "$root"
            ;;
        *)
            log_info "No special configuration needed"
            ;;
    esac

    echo ""
}

configure_wordpress() {
    local root="$1"

    # Create wp-config.php if only sample exists
    if [ ! -f "$root/wp-config.php" ] && [ -f "$root/wp-config-sample.php" ]; then
        log_info "WordPress: Creating wp-config.php from sample"
        cp "$root/wp-config-sample.php" "$root/wp-config.php"

        # Add dummy database configuration for analysis
        sed -i "s/database_name_here/codeql_analysis/g" "$root/wp-config.php" 2>/dev/null || true
        sed -i "s/username_here/codeql/g" "$root/wp-config.php" 2>/dev/null || true
        sed -i "s/password_here/codeql/g" "$root/wp-config.php" 2>/dev/null || true
    fi

    log_success "WordPress configured"
}

configure_laravel() {
    local root="$1"

    # Check for .env
    if [ ! -f "$root/.env" ] && [ -f "$root/.env.example" ]; then
        log_info "Laravel: Creating .env from .env.example"
        cp "$root/.env.example" "$root/.env"
    fi

    log_success "Laravel configured"
}

configure_symfony() {
    local root="$1"

    # Symfony usually has .env already
    log_success "Symfony configured"
}

configure_drupal() {
    local root="$1"

    log_success "Drupal configured"
}

################################################################################
# Validation
################################################################################

validate_setup() {
    local root="$1"

    log_info "Validating setup"

    local errors=0

    # Check if PHP files exist
    if [ $(count_php_files "$root") -eq 0 ]; then
        log_error "No PHP files found in $root"
        errors=$((errors + 1))
    else
        log_success "PHP files found"
    fi

    # Check for common issues
    if [ -d "$root" ] && [ -w "$root" ]; then
        log_success "Source directory is readable and writable"
    else
        log_error "Source directory is not readable or writable"
        errors=$((errors + 1))
    fi

    if [ $errors -gt 0 ]; then
        return 1
    fi

    return 0
}

################################################################################
# Summary Report
################################################################################

print_summary() {
    local root="$1"
    local project_type="$2"
    local php_count="$3"

    echo ""
    log_success "Build Summary"
    echo "  Project Type: $project_type"
    echo "  PHP Files: $php_count"
    echo "  Source Root: $root"
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    log_info "Starting PHP autobuilder"
    echo ""

    # Detect project type
    local project_type=$(detect_project_type "$SOURCE_ROOT")
    log_success "Detected project type: $project_type"
    echo ""

    # Analyze project
    analyze_project "$SOURCE_ROOT" "$project_type"

    # Setup environment
    setup_environment "$SOURCE_ROOT" "$project_type"

    # Configure project
    configure_project "$SOURCE_ROOT" "$project_type"

    # Validate setup
    if ! validate_setup "$SOURCE_ROOT"; then
        log_error "Validation failed"
        exit 1
    fi
    echo ""

    # Generate TRAP
    local php_count=$(count_php_files "$SOURCE_ROOT")
    generate_trap "$SOURCE_ROOT" "$project_type" "$TRAP_OUTPUT"

    # Print summary
    print_summary "$SOURCE_ROOT" "$project_type" "$php_count"

    log_success "Autobuilder completed successfully"
    echo ""

    # The actual extraction happens through the Rust extractor
    # This script just handles project detection and configuration
}

main "$@"
