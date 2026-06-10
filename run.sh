#!/bin/bash

# ------------------------------------------------------------------------
# ixi-Simflow 전용 실행 및 실시간 로깅 스크립트 (run.sh)
# ------------------------------------------------------------------------

# 에러 발생 시 즉시 스크립트 중단
set -e

# 로그 가독성을 위한 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 로깅용 헬퍼 함수
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
log_info "  ixi-Simflow Custom Pipeline Execution Started        "
log_info "======================================================="

# 1. pip 최신화 및 의존성 환경 세팅
log_info "[Step 1] pip 및 환경 설정 최신화를 진행합니다."
pip install --upgrade pip

# 2. requirements.txt 체크 및 설치/생성
log_info "[Step 2] 의존성 패키지(requirements.txt)를 체크합니다."
if [ -f "requirements.txt" ]; then
    log_info "기존 requirements.txt를 발견했습니다. 패키지 설치를 시작합니다."
    pip install -r requirements.txt
else
    log_warn "requirements.txt 파일이 존재하지 않습니다."
    log_info "현재 환경의 기본 핵심 패키지 기반으로 requirements.txt를 자동 생성합니다."
    
    # 현재 환경에 설치된 패키지 리스트 저장
    pip freeze > requirements.txt
    log_info "requirements.txt 생성이 완료되었습니다."
fi

# 3. 메인 파이썬 스크립트 실행 및 실시간 프린트 로깅 처리
log_info "[Step 3] 메인 파이썬 스크립트를 실행합니다."

# 실행할 파이썬 파일명 (위에서 작성한 main.py와 매칭)
MAIN_SCRIPT="main.py"

if [ -f "$MAIN_SCRIPT" ]; then
    log_info "${MAIN_SCRIPT} 실행을 시작합니다. (ixi-Simflow 실시간 로그 전송 중...)"
    
    # 💡 CRITICAL POINT: 
    # 'python -u' 옵션은 버퍼링 없이 즉시 표준 출력(stdout)을 밀어냅니다.
    # 이 옵션이 없으면 플랫폼 대시보드 로그가 멈춰있다가 한참 뒤에 나오거나, 
    # 에러 발생 시 로그가 유실될 수 있습니다.
    # 2>&1 | tee -a pipeline.log 를 통해 화면 출력과 동시에 파일로도 저장합니다.
    python -u "$MAIN_SCRIPT" 2>&1 | tee -a pipeline_run.log
    
    log_info "======================================================="
    log_info "  ixi-Simflow Custom Pipeline Completed Successfully  "
    log_info "======================================================="
else
    log_error "실행할 메인 파일(${MAIN_SCRIPT})을 찾을 수 없습니다."
    log_error "Git 저장소에 메인 스크립트가 포함되어 있는지 확인해주세요."
    exit 1
fi
