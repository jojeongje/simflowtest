import os
import json
import logging
from http.server import BaseHTTPRequestHandler, HTTPServer

# ------------------------------------------------------------------------
# ixi-Simflow 플랫폼 규칙
# ------------------------------------------------------------------------
OUTPUT_DIR = "/simflow/output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

HOST = "0.0.0.0"
PORT = 38000

# 로깅 설정
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)
logger = logging.getLogger(__name__)


class SimflowHandler(BaseHTTPRequestHandler):

    def send_json(self, status_code, data):
        response = json.dumps(data, ensure_ascii=False).encode("utf-8")

        self.send_response(status_code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(response)))
        self.end_headers()

        self.wfile.write(response)

    def do_GET(self):
        logger.info(f"GET {self.path}")

        # Health Check
        if self.path == "/health":
            self.send_json(200, {
                "status": "ok",
                "service": "ixi-simflow-dummy-api"
            })
            return

        # 기본 API
        if self.path == "/":
            self.send_json(200, {
                "message": "ixi-Simflow Dummy API",
                "status": "running",
                "port": PORT
            })
            return

        # Model 정보
        if self.path == "/model":
            self.send_json(200, {
                "model_type": "simflow-test-model",
                "version": "v1.0",
                "status": "success"
            })
            return

        self.send_json(404, {
            "error": "Not Found",
            "path": self.path
        })

    def do_POST(self):
        logger.info(f"POST {self.path}")

        # /predict API
        if self.path == "/predict":
            content_length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(content_length)

            try:
                request_data = json.loads(body.decode("utf-8"))
            except json.JSONDecodeError:
                self.send_json(400, {
                    "error": "Invalid JSON"
                })
                return

            logger.info(f"Prediction request: {request_data}")

            # 더미 추론 결과
            self.send_json(200, {
                "status": "success",
                "model": "simflow-test-model",
                "version": "v1.0",
                "input": request_data,
                "prediction": "dummy-result"
            })
            return

        self.send_json(404, {
            "error": "Not Found",
            "path": self.path
        })


def main():
    logger.info("🚀 ixi-Simflow Dummy API 시작")
    logger.info(f"📡 서버 주소: http://{HOST}:{PORT}")

    server = HTTPServer((HOST, PORT), SimflowHandler)

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        logger.info("🛑 서버 종료 요청")
    finally:
        server.server_close()
        logger.info("✅ 서버 종료 완료")


if __name__ == "__main__":
    main()
