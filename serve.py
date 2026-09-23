import http.server
import socketserver
import os
import sys

PORT = int(os.environ.get("PORT", 3055))
ROOT = os.path.dirname(os.path.abspath(__file__))


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROOT, **kwargs)

    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

    def guess_type(self, path):
        t = super().guess_type(path)
        if path.endswith(".js"):
            return "application/javascript"
        return t

    def log_message(self, fmt, *args):
        sys.stdout.write(f"[{self.log_date_time_string()}] {fmt % args}\n")
        sys.stdout.flush()


class Server(socketserver.TCPServer):
    allow_reuse_address = True


def main():
    os.chdir(ROOT)
    print(f"Serving '{ROOT}'")
    print(f"Listening on 0.0.0.0:{PORT}")
    try:
        with Server(("0.0.0.0", PORT), Handler) as httpd:
            sys.stdout.flush()
            httpd.serve_forever()
    except OSError as e:
        print(f"Port {PORT} unavailable: {e}")
        sys.exit(1)
    except KeyboardInterrupt:
        print("\nStopped.")


if __name__ == "__main__":
    main()
