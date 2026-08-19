#!/bin/bash

# ------------------------------------------------------------------------
# ixi-Simflow Dummy API Server 실행 스크립트 (run.sh)
# ------------------------------------------------------------------------

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] [WARN] $1${NC}"
}

log_error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] [ERROR] $1${NC}"
}

log_info "======================================================="
log_info "      ixi-Simflow Dummy API Server Starting           "
log_info "======================================================="

# ------------------------------------------------------------------------
# 1. 실행 환경 확인
# ------------------------------------------------------------------------
log_info "[Step 1] Python 실행 환경을 확인합니다."

if ! command -v python >/dev/null 2>&1; then
    log_error "python 명령을 찾을 수 없습니다."
    exit 1
fi

python --version

# ------------------------------------------------------------------------
# 2. 메인 API 서버 확인
# ------------------------------------------------------------------------
MAIN_SCRIPT="main.py"

log_info "[Step 2] API 서버 스크립트를 확인합니다."

if [ ! -f "$MAIN_SCRIPT" ]; then
    log_error "${MAIN_SCRIPT} 파일을 찾을 수 없습니다."
    exit 1
fi

# ------------------------------------------------------------------------
# 3. API 서버 실행
# ------------------------------------------------------------------------
log_info "[Step 3] Dummy API 서버를 시작합니다."
log_info "Listen Address : 0.0.0.0"
log_info "Listen Port    : 8000"
log_info "Health Check   : /health"
log_info "Model API      : /model"
log_info "Predict API    : /predict"

log_info "======================================================="
log_info "          API Server is Ready                         "
log_info "======================================================="

# Python stdout/stderr 버퍼링 없이 실행
# 서버 프로세스가 계속 실행되도록 유지
exec python -u "$MAIN_SCRIPT"
