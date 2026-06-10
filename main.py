import os
import time
import logging

# ------------------------------------------------------------------------
# ixi-Simflow 플랫폼 규칙: 산출물은 반드시 아래 경로에 저장해야 함
# ------------------------------------------------------------------------
OUTPUT_DIR = "/simflow/output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

# 로깅 설정 (run.sh의 표준 출력 캡처와 연동)
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)

def main():
    logger.info("🚀 ixi-Simflow 테스트 파이프라인 시작")

    # 1. 데이터 로드 단계 (Mock)
    # 실제로는 Data Foundry에서 준비된 데이터셋 경로를 읽어옵니다.
    logger.info("학습 데이터 로딩 중...")
    time.sleep(2) 
    logger.info("✅ 데이터 로드 완료")

    # 2. 모델 학습/최적화 루프 (Mock)
    logger.info("모델 연산을 시작합니다.")
    epochs = 3
    for epoch in range(1, epochs + 1):
        logger.info(f"Epoch {epoch}/{epochs} 진행 중...")
        time.sleep(3) # 실제 GPU 연산 대기 시간 시뮬레이션
        logger.info(f"Epoch {epoch} 완료 - Loss: {0.8 / epoch:.4f}")

    # 3. 최종 산출물 저장 (핵심)
    logger.info("연산 완료. 산출물을 플랫폼 Model Registry(OUTPUT_DIR) 경로에 저장합니다.")
    
    # 예시: 가중치 및 설정 파일 저장
    dummy_model_path = os.path.join(OUTPUT_DIR, "model_weights.bin")
    dummy_config_path = os.path.join(OUTPUT_DIR, "config.json")

    with open(dummy_model_path, "wb") as f:
        f.write(b"dummy weights data for simflow registry test")
    
    with open(dummy_config_path, "w", encoding="utf-8") as f:
        f.write('{"model_type": "simflow-test-model", "version": "v1.0", "status": "success"}')

    logger.info(f"✅ 모델 저장 완료: {OUTPUT_DIR}")
    logger.info("🎉 파이프라인 정상 종료")

if __name__ == "__main__":
    main()
