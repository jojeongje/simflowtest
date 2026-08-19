#!/bin/bash

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

echo "================================================="
echo "🚀 ixi-Simflow Dummy API Server"
echo "================================================="

# -------------------------------------------------
# 1. Python 환경
# -------------------------------------------------
log_info "Python 버전 확인"
python --version

# -------------------------------------------------
# 2. 서버 IP 확인
# -------------------------------------------------
log_info "서버 네트워크 정보를 확인합니다."

SERVER_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || true)

if [ -z "$SERVER_IP" ]; then
    SERVER_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || true)
fi

if [ -z "$SERVER_IP" ]; then
    SERVER_IP="IP 확인 불가"
    log_warn "서버 IP를 자동으로 확인하지 못했습니다."
fi

log_info "Server IP       : ${SERVER_IP}"
log_info "Listen Address  : 0.0.0.0"
log_info "Listen Port     : 38000"

# -------------------------------------------------
# 3. 접속 URL 출력
# -------------------------------------------------
if [ "$SERVER_IP" != "IP 확인 불가" ]; then
    log_info "Health Check    : http://${SERVER_IP}:38000/health"
    log_info "Root API        : http://${SERVER_IP}:38000/"
    log_info "Model API       : http://${SERVER_IP}:38000/model"
    log_info "Predict API     : http://${SERVER_IP}:38000/predict"
else
    log_info "Health Check    : http://<SERVER_IP>:38000/health"
fi

log_info "================================================="
log_info "API 서버를 시작합니다."
log_info "================================================="

# -------------------------------------------------
# 4. API 서버 실행
# -------------------------------------------------
exec python -u main.py
